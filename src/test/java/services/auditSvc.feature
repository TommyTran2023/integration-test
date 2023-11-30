Feature: Audit Service

    @GetListAuditLog
    Scenario: Get List Audit Log
        Given path 'audit/audit-log'
        * header authorization = authorization
        * params params
        When method GET

    @GetAuditLogDetail
    Scenario: Get Audit Log Detail
       Given path 'audit/audit-log/' + auditLogId
       * header authorization = authorization
       When method GET
    
    @GetListCategoryData
    Scenario: Get List Category Data
        Given path 'audit/audit-log/category/group-by-field'
        * header authorization = authorization
        * params params
        When method GET

    @ExportAuditLogListing
    Scenario: Export Audit Log Listing
        Given path 'audit/audit-log/logging/export'
        * header authorization = authorization
        * params params
        When method GET

