<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="html" encoding="UTF-8"/>
    <xsl:template match="/">
        <html>
            <body>
                <h1>Extraction du patron NOM ADJ</h1>
                <table>
                    <tr>
                        <td>
                            <xsl:apply-templates select="//item"/>
                        </td>
                    </tr>
                </table>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="item">
                <xsl:apply-templates select="./titre/document/article/element"/>
    </xsl:template>
    <xsl:template match="element">
        <xsl:choose>
            <xsl:when
                test="(./data[contains(text(), 'NOM')]) and (following-sibling::element[1][./data[contains(text(), 'ADJ')]])">
                <xsl:value-of select="./data[3]"/>
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when
                test="(./data[contains(text(), 'ADJ')]) and (preceding-sibling::element[1][./data[contains(text(), 'NOM')]])">
                <xsl:value-of select="./data[3]"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
