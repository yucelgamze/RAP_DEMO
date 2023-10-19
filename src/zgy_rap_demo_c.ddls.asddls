@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Student'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZGY_RAP_DEMO_C
  provider contract transactional_query
  as projection on ZGY_RAP_DEMO_I as Student
{
      @EndUserText.label: 'Student ID'
  key Id,
      @EndUserText.label: 'First Name'
      Firstname,
      @EndUserText.label: 'Last Name'
      Lastname,
      @EndUserText.label: 'Age'
      Age,
      @EndUserText.label: 'Course'
      Course,
      @EndUserText.label: 'Course Duration'
      Courseduration,
      @EndUserText.label: 'Status'
      Status,
      @EndUserText.label: 'Gender'
      Gender,

      Genderdesc,
      @EndUserText.label: 'Date Of Birth'
      Dob,
      Lastchangedat,
      Locallastchangedat,
      _academicres : redirected to composition child ZGY_RAP_DEMO_C_AR,
      _gender

}
