<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="common.xsl"/>
	<xsl:import href="../string.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>E-Mailの日付形式を扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-17</xsltdoc:version>
		<xsltdoc:since>2014-12-24</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="https://www.ietf.org/rfc/rfc5322.txt"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>E-Mailの日付形式を時間単位ごとに分割する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="E-Mailの日付形式"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックを適用するノードセット"/>
		<xsltdoc:paramAny xsltdoc:name="param1" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param2" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param3" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param4" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param5" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:return xsltdoc:short="各時間単位を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.email.parse">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.print']"/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>
		<xsl:param name="param4"/>
		<xsl:param name="param5"/>

		<xsl:variable name="normalized">
			<xsl:call-template name="cxsltl:string.substringAfter">
				<xsl:with-param name="string" select="translate(normalize-space($string), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
				<xsl:with-param name="substring" select="', '"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="day" select="substring-before($normalized, ' ')"/>

		<xsl:variable name="after1" select="substring-after($normalized, ' ')"/>

		<xsl:variable name="month" >
			<xsl:variable name="before" select="substring-before($after1, ' ')"/>

			<xsl:value-of select="$cxsltl:date.common.monthes[translate(@abbr, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') = $before]/@number"/>
		</xsl:variable>

		<xsl:variable name="after2" select="substring-after($after1, ' ')"/>

		<xsl:variable name="year">
			<xsl:variable name="before" select="substring-before($after2, ' ')"/>

			<xsl:choose>
				<xsl:when test="string-length($before) = 4">
					<xsl:value-of select="$before"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="((19 + ($before &lt;= 49)) * 100) + $before"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="after3" select="substring-after($after2, ' ')"/>

		<xsl:variable name="time" select="substring-before($after3, ' ')"/>

		<xsl:variable name="timezone">
			<xsl:variable name="before" select="substring-after($after3, ' ')"/>

			<xsl:choose>
				<xsl:when test="$before = 'UT' or $before = 'GMT'">+0000</xsl:when>
				<xsl:when test="$before = 'EST' or $before = 'CDT'">-0500</xsl:when>
				<xsl:when test="$before = 'CST' or $before = 'MDT'">-0600</xsl:when>
				<xsl:when test="$before = 'MST' or $before = 'PDT'">-0700</xsl:when>
				<xsl:when test="starts-with($before, '+') or starts-with($before, '-')">
					<xsl:value-of select="$before"/>
				</xsl:when>
				<xsl:otherwise>-0000</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="year" select="$year"/>
			<xsl:with-param name="month" select="$month"/>
			<xsl:with-param name="day" select="$day"/>
			<xsl:with-param name="hour" select="substring($time, 1, 2)"/>
			<xsl:with-param name="minute" select="substring($time, 4, 2)"/>
			<xsl:with-param name="second" select="substring(concat($time, ':00'), 7, 2)"/>
			<xsl:with-param name="timezoneSign" select="substring($timezone, 1, 1)"/>
			<xsl:with-param name="timezoneHour" select="substring($timezone, 2, 2)"/>
			<xsl:with-param name="timezoneMinute" select="substring($timezone, 4, 2)"/>
			<xsl:with-param name="param1" select="$param1"/>
			<xsl:with-param name="param2" select="$param2"/>
			<xsl:with-param name="param3" select="$param3"/>
			<xsl:with-param name="param4" select="$param4"/>
			<xsl:with-param name="param5" select="$param5"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>