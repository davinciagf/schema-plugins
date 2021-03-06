<?xml version="1.0" encoding="UTF-8"?>
<!-- FIXME: Use mcc:linkage to get URL of browse graphic 
     in place of mcc:fileName and mcc:fileDescription --> 
<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
						xmlns:gco="http://www.isotc211.org/2005/gco"
						xmlns:srv="http://www.isotc211.org/2005/srv/2.0/2013-03-28"
            xmlns:mri="http://www.isotc211.org/2005/mri/1.0/2013-03-28"
            xmlns:mcc="http://www.isotc211.org/2005/mcc/1.0/2013-03-28"
						xmlns:mds="http://www.isotc211.org/2005/mds/1.0/2013-03-28">

	<xsl:template match="mds:MD_Metadata|*[contains(@gco:isoType, 'MD_Metadata')]">
		<thumbnail>
			<xsl:for-each select="mri:identificationInfo/*/mri:graphicOverview/mcc:MD_BrowseGraphic
				">
				<xsl:choose>
					<xsl:when test="mcc:fileDescription/gco:CharacterString = 'large_thumbnail' and mcc:fileName/gco:CharacterString != ''">
						<large>
							<xsl:value-of select="mcc:fileName/gco:CharacterString" />
						</large>
					</xsl:when>
					<xsl:when test="mcc:fileDescription/gco:CharacterString = 'thumbnail' and mcc:fileName/gco:CharacterString != ''">
						<small>
							<xsl:value-of select="mcc:fileName/gco:CharacterString" />
						</small>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</thumbnail>
	</xsl:template>

</xsl:stylesheet>
