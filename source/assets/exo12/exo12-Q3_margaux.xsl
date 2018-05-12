<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    <xsl:output method="html" encoding="UTF-8"/>  
    <xsl:template match="/">
        <html>
            <body bgcolor="#81808E">
                <table align="center" width="90%" bgcolor="white" bordercolor="#3300FF" border="1">
                    
                    <tr bgcolor="#4E3A4A">
                        
                        <td width="70%" valign="top" bgcolor="black"><font color="white"><b>Patron Morphosyntaxique : NOM ADJ</b> : <b><font color="red">forme</font></b><i>[<font color="blue">lemme</font>|<font color="green">cat</font>]</i></font></td>
                    </tr>
                    <xsl:apply-templates select="//item"/>
                </table>
            </body>
        </html>   
    </xsl:template>
    
    <xsl:template match="item">
        <tr bgcolor="#C5BAC5">
            
            <td width="70%" valign="top">
                <xsl:apply-templates select="./title/article/element"/>
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template match="element">
        <xsl:choose>
            <xsl:when test="(./data[contains(text(),'NOM')]) and (following-sibling::element[1][./data[contains(text(),'ADJ')]])">
                <b><font color="yellow">
                    <xsl:value-of select="./data[@type='string']"/>
                </font>
                </b><i>[<font color="yellow">
                    <xsl:value-of select="./data[@type='lemma']"/>
                </font>|<font color="yellow">
                    <xsl:value-of select="./data[@type='type']"/></font>]</i><xsl:text> </xsl:text>
                
                
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="(./data[contains(text(),'ADJ')]) and (preceding-sibling::element[1][./data[contains(text(),'NOM')]])">
                <b><font color="yellow">
                    <xsl:value-of select="./data[@type='string']"/>
                </font>
                </b><i>[<font color="yellow">
                    <xsl:value-of select="./data[@type='lemma']"/>
                </font>|<font color="yellow">
                    <xsl:value-of select="./data[@type='type']"/></font>]</i><xsl:text> </xsl:text>   
                    
            </xsl:when>
            
            <xsl:otherwise>
                <b><font color="red">
                    <xsl:value-of select="./data[@type='string']"/>
                </font>
                </b><i>[<font color="blue">
                    <xsl:value-of select="./data[@type='lemma']"/>
                </font>|<font color="green">
                    <xsl:value-of select="./data[@type='type']"/></font>]</i><xsl:text> </xsl:text>
            </xsl:otherwise>   
        </xsl:choose>
        
    </xsl:template>
</xsl:stylesheet>    