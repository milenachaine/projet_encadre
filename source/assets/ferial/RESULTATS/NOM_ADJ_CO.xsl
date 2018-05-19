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
                                        <font color="green">
                                            <b>ADJ</b>
                                        </font>
                                    </h1>
                                </font>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <blockquote>
                                    <xsl:apply-templates select="//element"/>
                                </blockquote>
                            </td>
                        </tr>
                    </table>
                </body>
            </html>
        </xsl:template>
        <xsl:template match="element">
            <xsl:choose>
                <xsl:when test="(./data[contains(text(),'NOM')]) and (following-sibling::element[1][./data[contains(text(),'ADJ')]])">
                    <font color="red">
                        <xsl:value-of select="./data[3]"/>
                    </font>
                    <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:when test="(./data[contains(text(),'ADJ')]) and (preceding-sibling::element[1][./data[contains(text(),'NOM')]])">
                    <font color="green">
                        <xsl:value-of select="./data[3]"/>
                    </font>
                    <br/>
                </xsl:when>
            </xsl:choose>
        </xsl:template>
    </xsl:stylesheet>
