@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View Entity for Student'
@Metadata.ignorePropagatedAnnotations: true

@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZGY_RAP_DEMO_I
  as select from zgy_rap_demo_dt
  association to ZGY_RAP_DEMO_GENDER      as _gender on $projection.Gender = _gender.Value
  composition [0..*] of ZGY_RAP_DEMO_I_AR as _academicres
{
  key id                  as Id,
      firstname           as Firstname,
      lastname            as Lastname,
      age                 as Age,
      course              as Course,
      courseduration      as Courseduration,
      status              as Status,
      gender              as Gender,
      dob                 as Dob,
      lastchangedat       as Lastchangedat,
      locallastchangedat  as Locallastchangedat,
      _gender,
      _gender.Description as Genderdesc,
      _academicres
}
