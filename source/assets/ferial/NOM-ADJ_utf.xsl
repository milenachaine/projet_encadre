<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
        <xsl:output method="text" encoding="utf-8"/>
        <xsl:template match="/">
            <xsl:apply-templates select="//element"/>
        </xsl:template>
        <xsl:template match="element">
            <xsl:choose>
                <xsl:when test="(./data[contains(text(),'NOM')]) and (following-sibling::element[1][./data[contains(text(),'ADJ')]])">
                    <xsl:value-of select="./data[3]"/>
                    <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:when test="(./data[contains(text(),'ADJ')]) and (preceding-sibling::element[1][./data[contains(text(),'NOM')]])">
                    <xsl:value-of select="./data[3]"/>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:template>
</xsl:stylesheet>