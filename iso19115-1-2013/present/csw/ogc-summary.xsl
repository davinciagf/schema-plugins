<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
	xmlns:dc ="http://purl.org/dc/elements/1.1/"
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:mds="http://www.isotc211.org/2005/mds/1.0/2013-03-28"
	xmlns:mri="http://www.isotc211.org/2005/mri/1.0/2013-03-28"
	xmlns:cit="http://www.isotc211.org/2005/cit/1.0/2013-03-28"
	xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2013-03-28"
	xmlns:gex="http://www.isotc211.org/2005/gex/1.0/2013-03-28"
	xmlns:srv="http://www.isotc211.org/2005/srv/2.0/2013-03-28"
  xmlns:mco="http://www.isotc211.org/2005/mco/1.0/2013-03-28"
  xmlns:mrd="http://www.isotc211.org/2005/mrd/1.0/2013-03-28"
  xmlns:mrs="http://www.isotc211.org/2005/mrs/1.0/2013-03-28"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:geonet="http://www.fao.org/geonetwork"
	exclude-result-prefixes="mds srv mri cit mcc gex mco mcc mrd mrs gco">
	
	<xsl:param name="displayInfo"/>
	<xsl:param name="lang"/>
	
	<xsl:include href="../metadata-utils.xsl"/>
	
	<!-- ============================================================================= -->
	
	<xsl:template match="mds:MD_Metadata|*[contains(@gco:isoType,'MD_Metadata')]">
		
		<xsl:variable name="info" select="geonet:info"/>
		<xsl:variable name="langId">
			<xsl:call-template name="getLangId19115-1-2013">
				<xsl:with-param name="langGui" select="$lang"/>
				<xsl:with-param name="md" select="."/>
			</xsl:call-template>
		</xsl:variable>
		
		<csw:SummaryRecord>
			
			<xsl:for-each select="mds:metadataIdentifier">
				<dc:identifier><xsl:value-of select="mcc:MD_Identifier/mcc:code/gco:CharacterString"/></dc:identifier>
			</xsl:for-each>
			
			<!-- DataIdentification -->
			
			<xsl:for-each select="mds:identificationInfo/mri:MD_DataIdentification|
				mds:identificationInfo/*[contains(@gco:isoType, 'MD_DataIdentification')]|
				mds:identificationInfo/srv:SV_ServiceIdentification|
				mds:identificationInfo/*[contains(@gco:isoType, 'SV_ServiceIdentification')]">
				
				<xsl:for-each select="mri:citation/cit:CI_Citation/cit:title">
					<dc:title>
						<xsl:apply-templates mode="localised" select=".">
							<xsl:with-param name="langId" select="$langId"/>
						</xsl:apply-templates>
					</dc:title>
				</xsl:for-each>
				
				<!-- Type -->
				<xsl:for-each select="../../mds:metadataScope/mds:MD_MetadataScope/mds:resourceScope/mcc:MD_ScopeCode/@codeListValue">
					<dc:type><xsl:value-of select="."/></dc:type>
				</xsl:for-each>
				
				
				<xsl:for-each select="mri:descriptiveKeywords/mri:MD_Keywords/mri:keyword[not(@gco:nilReason)]">
					<dc:subject>
						<xsl:apply-templates mode="localised" select=".">
							<xsl:with-param name="langId" select="$langId"/>
						</xsl:apply-templates>
					</dc:subject>
				</xsl:for-each>
				<xsl:for-each select="mri:topicCategory/mri:MD_TopicCategoryCode">
					<dc:subject><xsl:value-of select="."/></dc:subject><!-- TODO : translate ? -->
				</xsl:for-each>
				
				<!-- Distribution -->
				
				<xsl:for-each select="../../mds:distributionInfo/mrd:MD_Distribution">
					<xsl:for-each select="mrd:distributionFormat/mrd:MD_Format/mrd:name">
						<dc:format>
							<xsl:apply-templates mode="localised" select=".">
								<xsl:with-param name="langId" select="$langId"/>
							</xsl:apply-templates>
						</dc:format>
					</xsl:for-each>
				</xsl:for-each>
				
				<!-- Parent Identifier -->
				
				<xsl:for-each select="../../mds:parentMetadata/mcc:MD_Identifier/mcc:code/gco:CharacterString">
					<dc:relation><xsl:value-of select="."/></dc:relation>
				</xsl:for-each>
			
        <!-- Resource modification date (metadata modification date is in 
             mds:MD_Metadata/mds:dateInfo  -->

				<xsl:for-each select="mri:citation/cit:CI_Citation/cit:date/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='revision']/cit:date/gco:Date">
					<dct:modified><xsl:value-of select="."/></dct:modified>
				</xsl:for-each>
				
				<xsl:for-each select="mri:abstract">
					<dct:abstract>
						<xsl:apply-templates mode="localised" select=".">
							<xsl:with-param name="langId" select="$langId"/>
						</xsl:apply-templates>
					</dct:abstract>
				</xsl:for-each>
				
			</xsl:for-each>
			
			<!-- Lineage 
			
			<xsl:for-each select="../../mds:dataQualityInfo/dqm:DQ_DataQuality/dqm:lineage/dqm:LI_Lineage/dqm:statement/gco:CharacterString">
				<dc:source><xsl:value-of select="."/></dc:source>
				</xsl:for-each>-->
			
			
			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>
			
		</csw:SummaryRecord>
	</xsl:template>
	
	<!-- ============================================================================= -->
	
	<xsl:template match="*">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	
	<!-- ============================================================================= -->
	
</xsl:stylesheet>
