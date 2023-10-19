@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gender Domain'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGY_RAP_DEMO_GENDER
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZGY_DO_GENDER' )
{
  key domain_name,
  key value_position,
      @Semantics.language: true
  key language,
      value_low as Value,
      @Semantics.text: true
      text      as Description
}
