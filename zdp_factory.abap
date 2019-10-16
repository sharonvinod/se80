*&---------------------------------------------------------------------*
*& Report  ZDP_FACTORY
*&
*&---------------------------------------------------------------------*
*& Description    : This program demonstrates ABAP Factory Method
*&                  Design Pattern
*& Program Author : Sharon Vinod
*&---------------------------------------------------------------------*
 
REPORT  zdp_factory.
 
*----------------------------------------------------------------------*
*       CLASS lcl_sale_document DEFINITION
*----------------------------------------------------------------------*
* Sale document
*----------------------------------------------------------------------*
CLASS lcl_sale_document DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: write ABSTRACT.
ENDCLASS.                    "lcl_sale_document DEFINITION
 
*----------------------------------------------------------------------*
*       CLASS lcl_quotation  DEFINITIO
*----------------------------------------------------------------------*
* Quotation
*----------------------------------------------------------------------*
CLASS lcl_quotation DEFINITION
      INHERITING FROM lcl_sale_document.
  PUBLIC SECTION.
    METHODS: write REDEFINITION.
ENDCLASS.                    "lcl_quotation  DEFINITIO
 
*----------------------------------------------------------------------*
*       CLASS lcl_quotation IMPLEMENTATION
*----------------------------------------------------------------------*
* Quotation implementation
*----------------------------------------------------------------------*
CLASS lcl_quotation IMPLEMENTATION.
  METHOD write.
    WRITE: 'Quotation'.
  ENDMETHOD.                    "write
ENDCLASS.                    "lcl_quotation IMPLEMENTATION
 
*----------------------------------------------------------------------*
*       CLASS lcl_order  DEFINITIO
*----------------------------------------------------------------------*
* Sale order
*----------------------------------------------------------------------*
CLASS lcl_order DEFINITION
      INHERITING FROM lcl_sale_document.
  PUBLIC SECTION.
    METHODS: write REDEFINITION.
ENDCLASS.                    "lcl_order  DEFINITIO
 
*----------------------------------------------------------------------*
*       CLASS lcl_order IMPLEMENTATION
*----------------------------------------------------------------------*
* Sale Order implementation
*----------------------------------------------------------------------*
CLASS lcl_order IMPLEMENTATION.
  METHOD write.
    WRITE: 'Order'.
  ENDMETHOD.                    "write
ENDCLASS.                    "lcl_order IMPLEMENTATION
 
*----------------------------------------------------------------------*
*       INTERFACE lif_sale_document_factory IMPLEMENTATION
*----------------------------------------------------------------------*
* Sale document factor interface
*----------------------------------------------------------------------*
INTERFACE lif_sale_document_factory.
  METHODS:
        create IMPORTING im_docty TYPE vbtyp
              RETURNING value(re_doc) TYPE REF TO lcl_sale_document.
ENDINTERFACE.                    "lif_sale_document_factory IMPLEMENTATION
 
*----------------------------------------------------------------------*
*       CLASS lcl_sale_document_factory DEFINITION
*----------------------------------------------------------------------*
* Sale document factory
*----------------------------------------------------------------------*
CLASS lcl_sale_document_factory DEFINITION.
  PUBLIC SECTION.
    INTERFACES:
      lif_sale_document_factory.
    ALIASES: create FOR lif_sale_document_factory~create.
ENDCLASS.                    "lcl_sale_document_factory DEFINITION
 
*----------------------------------------------------------------------*
*       CLASS lcl_sale_document_factory IMPLEMENTATION
*----------------------------------------------------------------------*
* Sale document factory implementation
*----------------------------------------------------------------------*
CLASS lcl_sale_document_factory IMPLEMENTATION.
  METHOD create.
    DATA: lo_doc TYPE REF TO lcl_sale_document.
    CASE im_docty.
      WHEN 'B'.
        CREATE OBJECT lo_doc TYPE lcl_quotation.
      WHEN 'C'.
        CREATE OBJECT lo_doc TYPE lcl_order.
      WHEN OTHERS.
        " default, create order
        CREATE OBJECT lo_doc TYPE lcl_order.
    ENDCASE.
    re_doc = lo_doc.
  ENDMETHOD.                    "create
ENDCLASS.                    "lcl_sale_document_factory IMPLEMENTATION
 
DATA:
    go_doc TYPE REF TO lcl_sale_document,
    go_sale_document_factory TYPE REF TO lif_sale_document_factory.
 
PARAMETERS:
    pa_docty TYPE vbtyp. " B quotation, C order
 
START-OF-SELECTION.
  " create factory
  CREATE OBJECT go_sale_document_factory
      TYPE lcl_sale_document_factory.
 
  " create sale document at runtime.
  go_doc = go_sale_document_factory->create( pa_docty ).
  go_doc->write( ).
