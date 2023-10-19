@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View Entity for Academic Result'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGY_RAP_DEMO_I_AR
  as select from zgy_rap_demo_dt2
  //  header tabloyu association olarak ekliyoruz
  association to parent ZGY_RAP_DEMO_I as _student  on $projection.Id = _student.Id
  association to ZGY_RAP_DEMO_course   as _course   on $projection.Course = _course.Value
  association to ZGY_RAP_DEMO_Sem      as _semester on $projection.Semester = _semester.Value
  association to ZGY_RAP_DEMO_SEMRES   as _semres   on $projection.Semresult = _semres.Value
{
  key id                     as Id,
  key course                 as Course,
  key semester               as Semester,
      _course.Description    as course_desc,
      _semester.Description  as semester_desc,
      semresult              as Semresult,
      _semres.Description    as semres_desc,
      _student,
      _student.Lastchangedat as Lastchangedat

}
