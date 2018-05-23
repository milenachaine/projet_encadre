<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" encoding="utf-8"/>
    <xsl:template match="/">
        <html>
            <body>
                <h1>Extraction du patron VER:infi DET:ART NOM ADJ</h1>
                <table>
                    <tr>
                        <td>
                            <xsl:apply-templates select="//item"/>
                        </td>
                    </tr>
                </table>
            </body>
        </html>
        <xsl:apply-templates select=".//article"/>
    </xsl:template>
    <xsl:template match="item">
        <xsl:apply-templates select="./titre/document/article"/>
    </xsl:template>

    <xsl:template match="article">
        <xsl:for-each select="element">
            <xsl:if test="(./data[1][contains(text(), 'VER:infi')])">
                <xsl:variable name="a" select="./data[3]/text()"/>
                <xsl:if test="following-sibling::element[1][./data[1][contains(text(), 'DET:ART')]]">
                    <xsl:variable name="b" select="following-sibling::element[1]/data[3]/text()"/>
                    <xsl:if test="following-sibling::element[2][./data[1][contains(text(), 'NOM')]]">
                        <xsl:variable name="c" select="following-sibling::element[2]/data[3]/text()"/>
                        <xsl:if
                            test="following-sibling::element[3][./data[1][contains(text(), 'ADJ')]]">
                            <xsl:variable name="d"
                                select="following-sibling::element[3]/data[3]/text()"/>
                            <xsl:value-of select="$a"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$b"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$c"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$d"/>
                            <xsl:text>&#xA;</xsl:text>
                        </xsl:if>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>
