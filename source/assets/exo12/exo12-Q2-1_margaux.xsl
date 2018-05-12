<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8"/>

<xsl:template match="/">
    <html>
        <body  bgcolor="#81808E">
            <table align="center" width="50%"  bgcolor="white" bordercolor="#3300FF" border="1">
                <tr bgcolor="black">
                    <td width="90%" valign="top"><font color="white"><h1>Extraction de patron <font color="red"><b>NOM</b></font><xsl:text> </xsl:text><font color="blue"><b>ADJ</b></font></h1></font></td>
                </tr>
                <tr><td>
                    <blockquote><xsl:apply-templates select="./parcours/item/title/article"/></blockquote></td></tr>
            </table>
        </body>
    </html>
<xsl:apply-templates select="//element"/>
</xsl:template>

<xsl:template match="element">
<xsl:choose>
<xsl:when test="(./data[contains(text(),'NOM')]) and (following-sibling::element[1][./data[contains(text(),'ADJ')]])">
    <font color="red"><xsl:value-of select="./data[3]"/></font><xsl:text> </xsl:text>
</xsl:when>
<xsl:when test="(./data[contains(text(),'ADJ')]) and (preceding-sibling::element[1][./data[contains(text(),'NOM')]])">
    <font color="blue"><xsl:value-of select="./data[3]"/></font>
    <br/>
</xsl:when>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
