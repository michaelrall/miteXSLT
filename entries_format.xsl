<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="Customer" select="document('customer.xml')/customer"/>

	<xsl:template match="/">
		<html>
			<head>
				<link rel="stylesheet" href="style.css"/>
			</head>
			<body class="page">
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="replace">
	    <xsl:param name="string"/>
	    <xsl:choose>
		<xsl:when test="contains($string,'&#10;')">
		    <xsl:value-of select="substring-before($string,'&#10;')"/>
		    <br/>
		    <xsl:call-template name="replace">
		        <xsl:with-param name="string" select="substring-after($string,'&#10;')"/>
		    </xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:value-of select="$string"/>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:template>

	<xsl:template name="formatDate">
	    <xsl:param name="date" />
	    <xsl:variable name="year" select="substring-before($date, '-')" />
	    <xsl:variable name="month" select="substring-before(substring-after($date, '-'), '-')" />
	    <xsl:variable name="day" select="substring-after(substring-after($date, '-'), '-')" />
	    <xsl:value-of select="concat($day, '.', $month, '.', $year)" />
	</xsl:template>		

	<xsl:template match="time-entries">
		<table style="width:100%;"><tr><td style="width:50%;"><h1>Stundennachweis</h1></td><td style="width:50%;text-align:right;"><h1>[John Debug]</h1></td></tr></table>
		<table>
			<tr><td style="width:30mm;"><h2>Kunde:</h2></td><td><h2><xsl:value-of select="$Customer/name"/></h2></td></tr>
			<tr><td></td><td><h3><xsl:call-template name="replace"><xsl:with-param name="string" select="$Customer/note"/></xsl:call-template></h3></td></tr>
		</table>
		<table class="entries" cellspacing="0" cellpadding="0">
			<tr>
				<th style="width:30mm;">Datum</th>
				<th style="width:40mm;">Projekt</th>
				<th>Tätigkeit</th>
				<th style="text-align:right;width:40mm;">Dauer [Std]</th>
			</tr>
			<xsl:for-each select="time-entry" group-by="date-at">
				<!--<xsl:sort select="date-at"/>-->
				<xsl:if test="not(preceding-sibling::time-entry[1]/date-at = date-at)">
					<tr><td>&#160;</td><td></td><td></td></tr>
				</xsl:if>
				<tr>
					<td>

						<xsl:if test="not(preceding-sibling::time-entry[1]/date-at = date-at)">
						    <xsl:call-template name="formatDate">
							<xsl:with-param name="date" select="date-at" />
						    </xsl:call-template>
						</xsl:if>
					</td>
					<td>
						<xsl:value-of select="project-name"/>
					</td>
					<td>
						<xsl:choose>
							<xsl:when test="note != ''"><xsl:call-template name="replace"><xsl:with-param name="string" select="note"/></xsl:call-template></xsl:when>
							<xsl:otherwise>diverses</xsl:otherwise>
						</xsl:choose>
					</td>
					<td style="text-align:right;">
						<xsl:value-of select="format-number(minutes div 60, '#.00')"/>
					</td>
				</tr>
			</xsl:for-each>
			<tr><td>&#160;</td><td></td><td></td></tr>
			<tr><td>&#160;</td><td></td><td></td></tr>
			<tr>
				<td/>
				<td colspan="2" style="font-weight:bold;background-color:#CCCCCC;">GESAMT</td>
				<td style="font-weight:bold;text-align:right;background-color:#CCCCCC;">
					<xsl:value-of select="format-number(sum(time-entry/minutes) div 60, '#.00')"/>
				</td>
			</tr>
		</table>
		<br/>
		<br/>
		<br/>
		<br/>
		<div style="width:80%;margin-left:10%;">
			<p>Gesehen und bestätigt</p>
			<br/>
			<br/>
			<hr/>
			<p>Datum, Unterschrift Kunde</p>
		</div>
	</xsl:template>

</xsl:stylesheet>

