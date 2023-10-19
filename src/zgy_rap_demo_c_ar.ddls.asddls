@EndUserText.label: 'Consumption View for Academic Result'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZGY_RAP_DEMO_C_AR
  as projection on ZGY_RAP_DEMO_I_AR
{
      @EndUserText.label: 'Student ID'
  key Id,
      @EndUserText.label: 'Course'
  key Course,
      @EndUserText.label: 'Semester'
  key Semester,
      @EndUserText.label: 'Course Description'
      course_desc,
      @EndUserText.label: 'Semester Description'
      semester_desc,
      @EndUserText.label: 'Semester Result'
      Semresult,
      @EndUserText.label: 'Semester Result Description'
      semres_desc,
      /* Associations */
      _student : redirected to parent ZGY_RAP_DEMO_C
}
