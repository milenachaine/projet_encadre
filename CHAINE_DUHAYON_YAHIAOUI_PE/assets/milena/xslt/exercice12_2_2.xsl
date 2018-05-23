<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="text" encoding="utf-8"/>
    <xsl:template match="/">
        <html>
            <body>
                <h1>Extraction du patron DET:ART NOM NAM</h1>
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
                <xsl:apply-templates select="./titre/document/article"/>
    </xsl:template>
    <xsl:template match="article">
        <xsl:for-each select="element">
            <xsl:if test="(./data[1][contains(text(), 'DET:ART')])">
                <xsl:variable name="a" select="./data[3]/text()"/>
                <xsl:if test="following-sibling::element[1][./data[1][contains(text(), 'NOM')]]">
                    <xsl:variable name="b" select="following-sibling::element[1]/data[3]/text()"/>
                    <xsl:if test="following-sibling::element[2][./data[1][contains(text(), 'NAM')]]">
                        <xsl:variable name="c" select="following-sibling::element[2]/data[3]/text()"/>
                        <xsl:value-of select="$a"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$b"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$c"/>
                        <xsl:text>&#xA;</xsl:text>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
