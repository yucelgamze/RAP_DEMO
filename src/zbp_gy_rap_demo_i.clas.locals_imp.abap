CLASS lhc_Student DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Student RESULT result.
    METHODS setadmitted FOR MODIFY
      IMPORTING keys FOR ACTION student~setadmitted RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR student RESULT result.
    METHODS validateage FOR VALIDATE ON SAVE
      IMPORTING keys FOR student~validateage.
    METHODS updatecourseduration FOR DETERMINE ON SAVE
      IMPORTING keys FOR student~updatecourseduration.
    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE student.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR student RESULT result.

    METHODS is_update_allowed
      RETURNING VALUE(update_allowed) TYPE abap_bool.

ENDCLASS.

CLASS lhc_Student IMPLEMENTATION.

  METHOD get_instance_authorizations.

    DATA: update_requested TYPE abap_bool,
          update_granted   TYPE abap_bool.

    READ ENTITIES OF zgy_rap_demo_i IN LOCAL MODE
    ENTITY Student
    FIELDS ( Status ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_studentdata)
    FAILED failed.

    CHECK lt_studentdata IS NOT INITIAL.

    update_requested = COND #( WHEN requested_authorizations-%update     = if_abap_behv=>mk-on
                               OR   requested_authorizations-%action-Edit = if_abap_behv=>mk-on
                               THEN abap_true ELSE abap_false ).

    LOOP AT lt_studentdata ASSIGNING FIELD-SYMBOL(<lfs_studentdata>).

      IF <lfs_studentdata>-Status = abap_false .

        IF update_requested = abap_true.
          update_granted = is_update_allowed(  ).

          IF update_granted = abap_false. " authorization check failed oldu yani
            APPEND VALUE #( %tky = <lfs_studentdata>-%tky ) TO failed-student.
            APPEND VALUE #( %tky = keys[ 1 ]-%tky
                            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                            text = 'Update Status için Authorization yoktur!!!') ) TO reported-student.
          ENDIF.
        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD setAdmitted.

*status değiştirme butonu için custom kod bloğu: EML -> Entity manipulation language

    MODIFY ENTITIES OF zgy_rap_demo_i IN LOCAL MODE
    ENTITY Student
    UPDATE
    FIELDS ( Status )
    WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = abap_true ) )

    FAILED failed
    REPORTED reported.

    "update işleminden sonra veri okunmalı:

    READ ENTITIES OF zgy_rap_demo_i IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(studentdata).
    result = VALUE #( FOR studentrecord IN studentdata
    ( %tky = studentrecord-%tky %param = studentrecord )
    ).

  ENDMETHOD.

  METHOD get_instance_features.

    "status yes ise setAdmitted butonu disabled olacak
    "status no ise setAdmitted butonu enabled olacak

    READ ENTITIES OF zgy_rap_demo_i IN LOCAL MODE
    ENTITY Student
    FIELDS ( Status ) WITH CORRESPONDING #( keys )
    RESULT DATA(studentadmitted)
    FAILED failed.

    result = VALUE #( FOR stud IN studentadmitted
    LET statusval = COND #( WHEN stud-Status = abap_true
                            THEN if_abap_behv=>fc-o-disabled
                            ELSE if_abap_behv=>fc-o-enabled )

                            IN ( %tky = stud-%tky
                                 %action-setAdmitted = statusval )
     ).

  ENDMETHOD.

  METHOD validateAge.

    READ ENTITIES OF zgy_rap_demo_i IN LOCAL MODE
    ENTITY Student
    FIELDS ( Age ) WITH CORRESPONDING #( keys )
    RESULT DATA(studentsAge).

    LOOP AT studentsAge INTO DATA(studentAge).

      IF studentAge-Age < 21.
        APPEND VALUE #( %tky = studentage-%tky ) TO failed-student.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text = 'Yaş 21 den az olamaz !') )
                        TO reported-student.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD updateCourseDuration.

    READ ENTITIES OF zgy_rap_demo_i IN LOCAL MODE
    ENTITY Student
    FIELDS ( Course ) WITH CORRESPONDING #( keys )
    RESULT DATA(studentsCourse).

    LOOP AT studentscourse INTO DATA(studentcourse).

      CASE studentcourse-Course.
        WHEN 'C'.
          MODIFY ENTITIES OF zgy_rap_demo_i IN LOCAL MODE
          ENTITY Student
          UPDATE
          FIELDS ( Courseduration ) WITH VALUE #( ( %tky = studentcourse-%tky Courseduration = 9 ) ).
        WHEN  'E'.
          MODIFY ENTITIES OF zgy_rap_demo_i IN LOCAL MODE
          ENTITY Student
          UPDATE
          FIELDS ( Courseduration ) WITH VALUE #( ( %tky = studentcourse-%tky Courseduration = 6 ) ).
        WHEN 'M'.
          MODIFY ENTITIES OF zgy_rap_demo_i IN LOCAL MODE
          ENTITY Student
          UPDATE
          FIELDS ( Courseduration ) WITH VALUE #( ( %tky = studentcourse-%tky Courseduration = 5 ) ).
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.

  METHOD precheck_update.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).

      "01 = değer güncellendi / değişti , 00 = değer değişmedi

      CHECK <lfs_entity>-%control-Course EQ '01' OR <lfs_entity>-%control-Courseduration EQ '01'.

      READ ENTITIES OF zgy_rap_demo_i IN LOCAL MODE
      ENTITY Student
      FIELDS ( Courseduration ) WITH VALUE #( ( %key = <lfs_entity>-%key ) )
      RESULT DATA(lt_checkeddata).

      IF sy-subrc IS INITIAL.

        READ TABLE lt_checkeddata ASSIGNING FIELD-SYMBOL(<lfs_db_check>) INDEX 1.

        IF sy-subrc IS INITIAL.

          " değişiklik yapılmışsa ya frontend değerini ya da database değerini alacak.

          <lfs_db_check>-Course = COND #( WHEN <lfs_entity>-%control-Course EQ '01'
                                          THEN <lfs_entity>-Course
                                          ELSE <lfs_db_check>-Course ).
          <lfs_db_check>-Courseduration = COND #( WHEN <lfs_entity>-%control-Courseduration EQ '01'
                                THEN <lfs_entity>-Courseduration
                                ELSE <lfs_db_check>-Courseduration ).

          IF <lfs_db_check>-Courseduration < 6.
            IF <lfs_db_check>-Course = 'C' OR <lfs_db_check>-Course = 'E'.

              APPEND VALUE #( %tky = <lfs_entity>-%tky ) TO failed-student.

              APPEND VALUE #( %tky = <lfs_entity>-%tky
                              %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                              text = 'Geçersiz Ders Saati!!!....') ) TO reported-student.

            ENDIF.
          ENDIF.


        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.

    IF requested_authorizations-%update      = if_abap_behv=>mk-on OR
       requested_authorizations-%action-Edit = if_abap_behv=>mk-on .

      IF is_update_allowed(  ) = abap_true.

        result-%update      = if_abap_behv=>auth-allowed.
        result-%action-Edit = if_abap_behv=>auth-allowed.

      ELSE.

        result-%update      = if_abap_behv=>auth-unauthorized.
        result-%action-Edit = if_abap_behv=>auth-unauthorized.

      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD is_update_allowed.

* bunu production environmentta kullanmamalıymışız! normalde authorization objesi olmalı
    update_allowed = abap_true.
*    update_allowed = abap_false.
  ENDMETHOD.

ENDCLASS.
