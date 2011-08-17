<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
		xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
		xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" 
		xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" 
		xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" 
		xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" 
		xmlns:xlink="http://www.w3.org/1999/xlink" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" 
		xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" 
		xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" 
		xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" 
		xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" 
		xmlns:math="http://www.w3.org/1998/Math/MathML" 
		xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" 
		xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" 
		xmlns:ooo="http://openoffice.org/2004/office" 
		xmlns:ooow="http://openoffice.org/2004/writer" 
		xmlns:oooc="http://openoffice.org/2004/calc" 
		xmlns:dom="http://www.w3.org/2001/xml-events" 
		xmlns:xforms="http://www.w3.org/2002/xforms" 
		xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
		xmlns:rpt="http://openoffice.org/2005/report" 
		xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2"
		xmlns:xhtml="http://www.w3.org/1999/xhtml" 
		xmlns:grddl="http://www.w3.org/2003/g/data-view#" 
		xmlns:tableooo="http://openoffice.org/2009/table" 
		xmlns:field="urn:openoffice:names:experimental:ooo-ms-interop:xmlns:field:1.0" 
		xmlns:formx="urn:openoffice:names:experimental:ooxml-odf-interop:xmlns:form:1.0" 
		xmlns:css3t="http://www.w3.org/TR/css3-text/" 
		office:version="1.2" 
		grddl:transformation="http://docs.oasis-open.org/office/1.2/xslt/odf2rdf.xsl"
		>
  
  <xsl:output 
      method="text" 
      indent="no"/>
  
  <xsl:strip-space elements="*"/>


  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text:p[string()]">
    <xsl:text>&#10;p. </xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:template>
  

  <!--
  <xsl:template match="text:p//draw:frame//draw:text-box">
    <xsl:text>&#10;-PICTURE-FRAME-BEGIN-&#10;</xsl:text>
    <xsl:apply-templates select="text:p//draw:frame//draw:image"/>
    <xsl:value-of select="."/>
    <xsl:text>&#10;-PICTURE-FRAME-END-&#10;</xsl:text>
  </xsl:template>
  -->
  
  
  <xsl:template match="//text:p//draw:frame//draw:image">
    <xsl:text>&#10;!</xsl:text>
    <xsl:value-of select="substring-after(@xlink:href,'/')"/>
    <xsl:text>!&#10;</xsl:text>
  </xsl:template>  
  
  
  <!-- header level ja content works -->
  <xsl:template match="text:h">
    <xsl:text>&#10;h</xsl:text>
    <xsl:value-of select="@text:outline-level"/><xsl:text>. </xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:template>
  
  <!-- bullet list works for all lists, so needs some work -->
  <xsl:template match="text:list-item">
    <xsl:text>* </xsl:text>
    <xsl:value-of select="text:p"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>
  
  
  <!-- table of contents, figures, tables work -->
  <xsl:template match="text:table-of-content">
    <xsl:text>{{toc}}</xsl:text>
  </xsl:template>
  
  <xsl:template match="text:illustration-index">
  </xsl:template>
  
  <xsl:template match="text:table-index">
  </xsl:template>
  
  
  <xsl:template match="table:table//table:table-row">
    <xsl:text>|</xsl:text>
    <xsl:for-each select="table:table-cell//text:p">
      <xsl:value-of select="."/>
      <xsl:text>|</xsl:text>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>  

</xsl:stylesheet>
