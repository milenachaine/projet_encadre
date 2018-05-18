<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    <xsl:output method="html" encoding="UTF-8"/>  
    <xsl:template match="/">
<html>
            <body bgcolor="black">
                <table align="center" width="90%" bgcolor="white" bordercolor="#3300FF" border="1">
                    
                    <tr bgcolor="#efd9d9">
                        
                        <td width="70%" valign="top" bgcolor="#686262"><font color="white"><b>Contenu avec TAG</b> : <b><font color="#ac0f0f">forme</font></b><i>[<font color="#0fac0f">lemme</font>|<font color="#0f0fac">cat</font>]</i></font></td>
                    </tr>
                    <xsl:apply-templates select="//item"/>
                </table>
            </body>
</html>   
    </xsl:template>
    
    <xsl:template match="item">
        <tr bgcolor="#efd9d9">
            
            <td width="70%" valign="top">
                <xsl:apply-templates select="./titre/document/article/element"/>
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template match="element">
        <b><font color="ac0f0f">
            <xsl:value-of select="./data[@type='string']"/>
        </font></b><i>[<font color="0fac0f">
            <xsl:value-of select="./data[@type='lemma']"/>
        </font>|<font color="0f0fac">
            <xsl:value-of select="./data[@type='type']"/>]</font></i><xsl:text> </xsl:text>
    </xsl:template>
</xsl:stylesheet>    