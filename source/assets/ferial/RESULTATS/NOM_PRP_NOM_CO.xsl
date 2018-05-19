<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    <xsl:output method="html"/>
    <xsl:template match="/">
        <html>
            <body bgcolor="#81808E">
                <table align="center" width="50%" bgcolor="white" bordercolor="#3300FF" border="1">
                    <tr bgcolor="black">
                        <td width="90%" valign="top">
                            <font color="white">
                                <h1>
                                    Extraction de patron
                                    <font color="red">
                                        <b>NOM</b>
                                    </font>
                                    <xsl:text></xsl:text>
                                    <font color="green">
                                        <b>PRP</b>
                                    </font>
                                    <xsl:text></xsl:text>
                                    <font color="red">
                                        <b>NOM</b>
                                    </font>
                                </h1>
                            </font>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <blockquote>
                                <xsl:apply-templates select=".//article"/>
                            </blockquote>
                        </td>
                    </tr>
                </table>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="article">
        <xsl:for-each select="element">
            <xsl:if test="(./data[contains(text(),'NOM')])">
                <xsl:variable name="p1" select="./data[3]/text()"/>
                <xsl:if test="following-sibling::element[1][./data[contains(text(),'PRP')]]">
                    <xsl:variable name="p2" select="following-sibling::element[1]/data[3]/text()"/>
                    <xsl:if test="following-sibling::element[2][./data[contains(text(),'NOM')]]">
                        <xsl:variable name="p3" select="following-sibling::element[2]/data[3]/text()"/>
                        <font color="red">
                            <xsl:value-of select="$p1"/>
                        </font>
                        <xsl:text></xsl:text>
                        <font color="green">
                            <xsl:value-of select="$p2"/>
                        </font>
                        <xsl:text></xsl:text>
                        <font color="red">
                            <xsl:value-of select="$p3"/>
                        </font>
                        <br/>
                        <xsl:text></xsl:text>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>