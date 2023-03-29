<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../common.xsl"/>
	<xsl:import href="../../string.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>ISO 8601を扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-06-09</xsltdoc:version>
		<xsltdoc:since>2017-06-06</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="https://en.wikipedia.org/wiki/ISO_8601"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:date.iso8601.datetime.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>日時の単位</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:date.iso8601.datetime.dateUnits" select="$cxsltl:date.iso8601.datetime.self/cxsltl:units[@xml:id = 'cxsltl.date.iso8601.datetime.dateUnits']"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>時間の単位</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:date.iso8601.datetime.timeUnits" select="$cxsltl:date.iso8601.datetime.self/cxsltl:units[@xml:id = 'cxsltl.date.iso8601.datetime.timeUnits']"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>タイムゾーンの単位</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:date.iso8601.datetime.timezoneUnits" select="$cxsltl:date.iso8601.datetime.self/cxsltl:units[@xml:id = 'cxsltl.date.iso8601.datetime.timezoneUnits']"/>

	<!-- ==============================
		# Units Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.date.iso8601.datetime.dateUnits">
		<xsltdoc:short>日時の単位</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:units xml:id="cxsltl.date.iso8601.datetime.dateUnits">
		<cxsltl:year name="Year" basicStart="1" extendedStart="1" length="4"/>
		<cxsltl:month name="Month" basicStart="5" extendedStart="6" length="2"/>
		<cxsltl:day name="Day" basicStart="7" extendedStart="9" length="2"/>
		<cxsltl:dayOfYear name="Day of year" basicStart="5" extendedStart="6" length="3"/>
		<cxsltl:week name="Week" basicStart="6" extendedStart="7" length="2"/>
		<cxsltl:weekNumber name="Week number" basicStart="8" extendedStart="10" length="1"/>
	</cxsltl:units>

	<xsltdoc:Element rdf:about="#cxsltl.date.iso8601.datetime.timeUnits">
		<xsltdoc:short>時間の単位</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:units xml:id="cxsltl.date.iso8601.datetime.timeUnits">
		<cxsltl:hour name="Hour" basicStart="1" extendedStart="1" length="2"/>
		<cxsltl:minute name="Minute" basicStart="3" extendedStart="4" length="2"/>
		<cxsltl:second name="Second" basicStart="5" extendedStart="7" length="2"/>
	</cxsltl:units>

	<xsltdoc:Element rdf:about="#cxsltl.date.iso8601.datetime.timezoneUnits">
		<xsltdoc:short>タイムゾーンの単位</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:units xml:id="cxsltl.date.iso8601.datetime.timezoneUnits">
		<cxsltl:sign name="Sign" basicStart="1" extendedStart="1" length="1"/>
		<cxsltl:hour name="Hour" basicStart="2" extendedStart="2" length="2"/>
		<cxsltl:minute name="Minute" basicStart="4" extendedStart="5" length="2"/>
	</cxsltl:units>

	<!-- ==============================
		# Date
	 ============================== -->

	<!-- ==============================
		## ‎Composited Unit of Date
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値が日付か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkDate">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkCalenderDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="$extended"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkWeekDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="$extended"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkOrdinalDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="$extended"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値が完全な日付か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkCompleteDate">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkCompleteDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkCompleteDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkYearMonthDay">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="$extended"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkYearWeekDay">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="$extended"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkOrdinalDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="$extended"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ==============================
		## Calender Date
	 ============================== -->

	<!-- ==============================
		### ‎Composited Unit of Calender Date
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値が年と月か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkYearMonth">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkYearMonth">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkYearMonth">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="check">
					<xsl:variable name="yearUnit" select="$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:year"/>
					<xsl:variable name="monthUnit" select="$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:month"/>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTimeUnit">
						<xsl:with-param name="year" select="substring($string, $yearUnit/@basicStart, $yearUnit/@length)"/>
						<xsl:with-param name="month" select="substring(
							$string,
							($monthUnit[not($extended)]/@basicStart | $monthUnit[$extended]/@extendedStart)
						)"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(
					number($check) and
					(not($extended) or substring($string, 5, 1) = '-')
				)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値が年と月と日か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkYearMonthDay">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkYearMonthDay">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkYearMonthDay">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="check">
					<xsl:variable name="yearUnit" select="$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:year"/>
					<xsl:variable name="monthUnit" select="$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:month"/>
					<xsl:variable name="dayUnit" select="$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:day"/>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTimeUnit">
						<xsl:with-param name="year" select="substring($string, $yearUnit/@basicStart, $yearUnit/@length)"/>
						<xsl:with-param name="month" select="substring(
							$string,
							($monthUnit[not($extended)]/@basicStart | $monthUnit[$extended]/@extendedStart),
							$monthUnit/@length
						)"/>
						<xsl:with-param name="day" select="substring(
							$string,
							($dayUnit[not($extended)]/@basicStart | $dayUnit[$extended]/@extendedStart)
						)"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(
					number($check) and
					(not($extended) or (
						(substring($string, 5, 1) = '-') and (substring($string, 8, 1) = '-')
					))
				)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値がカレンダーの日付か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkCalenderDate">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkCalenderDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkCalenderDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="length" select="string-length($string)"/>

				<xsl:choose>
					<xsl:when test="$length = 4">
						<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTimeUnit">
							<xsl:with-param name="year" select="$string"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$length = 7">
						<xsl:call-template name="cxsltl:date.iso8601.datetime.checkYearMonth">
							<xsl:with-param name="string" select="$string"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$length = 8 or $length = 10">
						<xsl:call-template name="cxsltl:date.iso8601.datetime.checkYearMonthDay">
							<xsl:with-param name="string" select="$string"/>
							<xsl:with-param name="extended" select="$extended"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ==============================
		## Week Date
	 ============================== -->

	<!-- ==============================
		### ‎Composited Unit of Week Date
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値が年と週か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkYearWeek">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkYearWeek">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkYearWeek">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="check">
					<xsl:variable name="yearUnit" select="$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:year"/>
					<xsl:variable name="weekUnit" select="$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:week"/>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTimeUnit">
						<xsl:with-param name="year" select="substring($string, $yearUnit/@basicStart, $yearUnit/@length)"/>
						<xsl:with-param name="week" select="substring(
							$string,
							($weekUnit[not($extended)]/@basicStart | $weekUnit[$extended]/@extendedStart)
						)"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(
					number($check) and
					substring($string, 5 + $extended, 1) = 'W' and
					(not($extended) or substring($string, 5, 1) = '-')
				)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値が年と週と曜日か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkYearWeekDay">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkYearWeekDay">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkYearWeekDay">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="check">
					<xsl:variable name="yearUnit" select="$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:year"/>
					<xsl:variable name="weekUnit" select="$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:week"/>
					<xsl:variable name="weekNumberUnit" select="$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:weekNumber"/>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTimeUnit">
						<xsl:with-param name="year" select="substring($string, $yearUnit/@basicStart, $yearUnit/@length)"/>
						<xsl:with-param name="week" select="substring(
							$string,
							($weekUnit[not($extended)]/@basicStart | $weekUnit[$extended]/@extendedStart),
							$weekUnit/@length
						)"/>
						<xsl:with-param name="weekNumber" select="substring(
							$string,
							($weekNumberUnit[not($extended)]/@basicStart | $weekNumberUnit[$extended]/@extendedStart)
						)"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(
					number($check) and
					substring($string, 5 + $extended, 1) = 'W' and
					(not($extended) or (
						(substring($string, 5, 1) = '-') and (substring($string, 9, 1) = '-')
					))
				)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値が週の日付か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkWeekDate">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkWeekDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkWeekDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="length" select="string-length($string)"/>

				<xsl:choose>
					<xsl:when test="$length = 7 or ($extended and $length = 8)">
						<xsl:call-template name="cxsltl:date.iso8601.datetime.checkYearWeek">
							<xsl:with-param name="string" select="$string"/>
							<xsl:with-param name="extended" select="$extended"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$length = 8 or $length = 10">
						<xsl:call-template name="cxsltl:date.iso8601.datetime.checkYearWeekDay">
							<xsl:with-param name="string" select="$string"/>
							<xsl:with-param name="extended" select="$extended"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ==============================
		## Ordinal Date
	 ============================== -->

	<!-- ==============================
		### ‎Composited Unit of Ordinal Date
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値が通算した日付か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkOrdinalDate">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkOrdinalDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkOrdinalDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="check">
					<xsl:variable name="yearUnit" select="$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:year"/>
					<xsl:variable name="dayOfYearUnit" select="$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:dayOfYear"/>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTimeUnit">
						<xsl:with-param name="year" select="substring($string, $yearUnit/@basicStart, $yearUnit/@length)"/>
						<xsl:with-param name="dayOfYear" select="substring(
							$string,
							($dayOfYearUnit[not($extended)]/@basicStart | $dayOfYearUnit[$extended]/@extendedStart)
						)"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(
					number($check) and
					(not($extended) or substring($string, 5, 1) = '-')
				)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ==============================
		# Time
	 ============================== -->

	<!-- ==============================
		## ‎Base Unit of Time
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値が時か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:paramNumber xsltdoc:name="checkTimeZone" xsltdoc:short="値にタイムゾーンを含むか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkHour">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>
		<xsl:param name="checkTimeZone" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkHour">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
						<xsl:with-param name="checkTimeZone" select="$checkTimeZone"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkHour">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
						<xsl:with-param name="checkTimeZone" select="$checkTimeZone"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="0 &lt; $checkTimeZone">
						<xsl:variable name="timezoneBefore">
							<xsl:call-template name="cxsltl:date.iso8601.datetime.timezoneBefore">
								<xsl:with-param name="string" select="$string"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:variable name="checkHour">
							<xsl:call-template name="cxsltl:date.iso8601.datetime.checkHour">
								<xsl:with-param name="string" select="$timezoneBefore"/>
								<xsl:with-param name="extended" select="$extended"/>
								<xsl:with-param name="checkTimeZone" select="0"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:variable name="checkTimeZoneResult">
							<xsl:call-template name="cxsltl:date.iso8601.datetime.checkTimeZone">
								<xsl:with-param name="string" select="substring($string, string-length($timezoneBefore) + 1)"/>
								<xsl:with-param name="extended" select="$extended"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:value-of select="number(
							number($checkHour) and
							(
								($checkTimeZone = 1 and number($checkTimeZoneResult)) or
								($checkTimeZone = 2 and ($string = $timezoneBefore or number($checkTimeZoneResult)))
							)
						)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTimeUnit">
							<xsl:with-param name="hour" select="$string"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ==============================
		## ‎Composited Unit of Time
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値が時と分か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:paramNumber xsltdoc:name="checkTimeZone" xsltdoc:short="値にタイムゾーンを含むか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkHourMinute">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>
		<xsl:param name="checkTimeZone" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkHourMinute">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
						<xsl:with-param name="checkTimeZone" select="$checkTimeZone"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkHourMinute">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
						<xsl:with-param name="checkTimeZone" select="$checkTimeZone"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="0 &lt; $checkTimeZone">
						<xsl:variable name="timezoneBefore">
							<xsl:call-template name="cxsltl:date.iso8601.datetime.timezoneBefore">
								<xsl:with-param name="string" select="$string"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:variable name="checkHourMinute">
							<xsl:call-template name="cxsltl:date.iso8601.datetime.checkHourMinute">
								<xsl:with-param name="string" select="$timezoneBefore"/>
								<xsl:with-param name="extended" select="$extended"/>
								<xsl:with-param name="checkTimeZone" select="0"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:variable name="checkTimeZoneResult">
							<xsl:call-template name="cxsltl:date.iso8601.datetime.checkTimeZone">
								<xsl:with-param name="string" select="substring($string, string-length($timezoneBefore) + 1)"/>
								<xsl:with-param name="extended" select="$extended"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:value-of select="number(
							number($checkHourMinute) and
							(
								($checkTimeZone = 1 and number($checkTimeZoneResult)) or
								($checkTimeZone = 2 and ($string = $timezoneBefore or number($checkTimeZoneResult)))
							)
						)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="check">
							<xsl:variable name="hourUnit" select="$cxsltl:date.iso8601.datetime.timeUnits/cxsltl:hour"/>
							<xsl:variable name="minuteUnit" select="$cxsltl:date.iso8601.datetime.timeUnits/cxsltl:minute"/>

							<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTimeUnit">
								<xsl:with-param name="hour" select="substring($string, $hourUnit/@basicStart, $hourUnit/@length)"/>
								<xsl:with-param name="minute" select="substring(
									$string,
									($minuteUnit[not($extended)]/@basicStart | $minuteUnit[$extended]/@extendedStart)
								)"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:value-of select="number(number($check) and (not($extended) or substring($string, 3, 1) = ':'))"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値が時と分と秒か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:paramNumber xsltdoc:name="checkTimeZone" xsltdoc:short="値にタイムゾーンを含むか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkHourMinuteSecond">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>
		<xsl:param name="checkTimeZone" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkHourMinuteSecond">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
						<xsl:with-param name="checkTimeZone" select="$checkTimeZone"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkHourMinuteSecond">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
						<xsl:with-param name="checkTimeZone" select="$checkTimeZone"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="0 &lt; $checkTimeZone">
						<xsl:variable name="timezoneBefore">
							<xsl:call-template name="cxsltl:date.iso8601.datetime.timezoneBefore">
								<xsl:with-param name="string" select="$string"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:variable name="checkHourMinuteSecond">
							<xsl:call-template name="cxsltl:date.iso8601.datetime.checkHourMinuteSecond">
								<xsl:with-param name="string" select="$timezoneBefore"/>
								<xsl:with-param name="extended" select="$extended"/>
								<xsl:with-param name="checkTimeZone" select="0"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:variable name="checkTimeZoneResult">
							<xsl:call-template name="cxsltl:date.iso8601.datetime.checkTimeZone">
								<xsl:with-param name="string" select="substring($string, string-length($timezoneBefore) + 1)"/>
								<xsl:with-param name="extended" select="$extended"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:value-of select="number(
							number($checkHourMinuteSecond) and
							(
								($checkTimeZone = 1 and number($checkTimeZoneResult)) or
								($checkTimeZone = 2 and ($string = $timezoneBefore or number($checkTimeZoneResult)))
							)
						)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="check">
							<xsl:variable name="hourUnit" select="$cxsltl:date.iso8601.datetime.timeUnits/cxsltl:hour"/>
							<xsl:variable name="minuteUnit" select="$cxsltl:date.iso8601.datetime.timeUnits/cxsltl:minute"/>
							<xsl:variable name="secondUnit" select="$cxsltl:date.iso8601.datetime.timeUnits/cxsltl:second"/>

							<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTimeUnit">
								<xsl:with-param name="hour" select="substring($string, $hourUnit/@basicStart, $hourUnit/@length)"/>
								<xsl:with-param name="minute" select="substring(
									$string,
									($minuteUnit[not($extended)]/@basicStart | $minuteUnit[$extended]/@extendedStart)
								)"/>
								<xsl:with-param name="second" select="substring(
									$string,
									($secondUnit[not($extended)]/@basicStart | $secondUnit[$extended]/@extendedStart),
									$secondUnit/@length
								)"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:value-of select="number(
							number($check) and
							(not($extended) or (
								(substring($string, 3, 1) = ':') and (substring($string, 6, 1) = ':')
							))
						)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値が時間か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:paramNumber xsltdoc:name="checkTimeZone" xsltdoc:short="値にタイムゾーンを含むか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkTime">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>
		<xsl:param name="checkTimeZone" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkTime">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
						<xsl:with-param name="checkTimeZone" select="$checkTimeZone"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkTime">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
						<xsl:with-param name="checkTimeZone" select="$checkTimeZone"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="naturalNumber">
					<xsl:call-template name="cxsltl:string.substringBefore">
						<xsl:with-param name="string">
							<xsl:call-template name="cxsltl:date.iso8601.datetime.timezoneBefore">
								<xsl:with-param name="string" select="translate($string, ',', '.')"/>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="substring">.</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="length" select="string-length($naturalNumber)"/>

				<xsl:choose>
					<xsl:when test="$length = 2">
						<xsl:call-template name="cxsltl:date.iso8601.datetime.checkHour">
							<xsl:with-param name="string" select="$string"/>
							<xsl:with-param name="extended" select="$extended"/>
							<xsl:with-param name="checkTimeZone" select="$checkTimeZone"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$length = 4 or $length = 5">
						<xsl:call-template name="cxsltl:date.iso8601.datetime.checkHourMinute">
							<xsl:with-param name="string" select="$string"/>
							<xsl:with-param name="extended" select="$extended"/>
							<xsl:with-param name="checkTimeZone" select="$checkTimeZone"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$length = 6 or $length = 8">
						<xsl:call-template name="cxsltl:date.iso8601.datetime.checkHourMinuteSecond">
							<xsl:with-param name="string" select="$string"/>
							<xsl:with-param name="extended" select="$extended"/>
							<xsl:with-param name="checkTimeZone" select="$checkTimeZone"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値がタイムゾーン検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkTimeZone">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkTimeZone">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkTimeZone">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="timezoneSign" select="substring($string, 1, 1)"/>

				<xsl:variable name="checkHourMinute">
					<xsl:choose>
						<xsl:when test="$string = 'Z' or $string = 'z'">1</xsl:when>
						<xsl:when test="$timezoneSign != '+' and $timezoneSign != '-'">0</xsl:when>
						<xsl:when test="$string = '-00' or $string = '-0000' or $string = '-00:00' or substring($string, 2, 2) = 24">0</xsl:when>
						<xsl:when test="string-length($string) = 3">
							<xsl:call-template name="cxsltl:date.iso8601.datetime.checkHour">
								<xsl:with-param name="string" select="substring($string, 2)"/>
								<xsl:with-param name="extended" select="$extended"/>
								<xsl:with-param name="checkTimeZone" select="0"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="cxsltl:date.iso8601.datetime.checkHourMinute">
								<xsl:with-param name="string" select="substring($string, 2)"/>
								<xsl:with-param name="extended" select="$extended"/>
								<xsl:with-param name="checkTimeZone" select="0"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:value-of select="$checkHourMinute"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ==============================
		# Date Time
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値が日付か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:paramNumber xsltdoc:name="checkTimeZone" xsltdoc:short="値にタイムゾーンを含むか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkDateTime">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>
		<xsl:param name="checkTimeZone" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTime">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
						<xsl:with-param name="checkTimeZone" select="$checkTimeZone"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTime">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
						<xsl:with-param name="checkTimeZone" select="$checkTimeZone"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="check">
					<xsl:variable name="normalized" select="translate($string, 't', 'T')"/>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkCompleteDate">
						<xsl:with-param name="string" select="substring-before($normalized, 'T')"/>
						<xsl:with-param name="extended" select="$extended"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkTime">
						<xsl:with-param name="string" select="substring-after($normalized, 'T')"/>
						<xsl:with-param name="extended" select="$extended"/>
						<xsl:with-param name="checkTimeZone" select="$checkTimeZone"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number($check = 11)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>値が何れかの日付または時間か検査する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="値"/>
		<xsltdoc:paramNumber xsltdoc:name="extended" xsltdoc:short="$stringを拡張形式として検査するか"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkDateTimePoint">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="extended" select="2"/>

		<xsl:choose>
			<xsl:when test="2 &lt;= $extended">
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTimePoint">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="0"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTimePoint">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="1"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="check">
					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDate">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="$extended"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkTime">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="$extended"/>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTime">
						<xsl:with-param name="string" select="$string"/>
						<xsl:with-param name="extended" select="$extended"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="number(boolean(number($check)))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>各時間単位を検査する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="year" xsltdoc:short="年"/>
		<xsltdoc:paramNumber xsltdoc:name="month" xsltdoc:short="月"/>
		<xsltdoc:paramNumber xsltdoc:name="day" xsltdoc:short="日"/>
		<xsltdoc:paramNumber xsltdoc:name="dayOfYear" xsltdoc:short="通算日"/>
		<xsltdoc:paramNumber xsltdoc:name="week" xsltdoc:short="週"/>
		<xsltdoc:paramNumber xsltdoc:name="weekNumber" xsltdoc:short="曜日番号"/>
		<xsltdoc:paramNumber xsltdoc:name="hour" xsltdoc:short="時"/>
		<xsltdoc:paramNumber xsltdoc:name="minute" xsltdoc:short="分"/>
		<xsltdoc:paramNumber xsltdoc:name="second" xsltdoc:short="秒"/>
		<xsltdoc:returnBoolean xsltdoc:short="真ならば1を、偽ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.checkDateTimeUnit">
		<xsl:param name="year">2004</xsl:param>
		<xsl:param name="month">01</xsl:param>
		<xsl:param name="day">01</xsl:param>
		<xsl:param name="dayOfYear">001</xsl:param>
		<xsl:param name="week">01</xsl:param>
		<xsl:param name="weekNumber">1</xsl:param>
		<xsl:param name="hour">00</xsl:param>
		<xsl:param name="minute">00</xsl:param>
		<xsl:param name="second">00</xsl:param>

		<xsl:variable name="normalizedHour" select="translate($hour, ',', '.')"/>
		<xsl:variable name="normalizedMinute" select="translate($minute, ',', '.')"/>
		<xsl:variable name="normalizedSecond" select="translate($second, ',', '.')"/>
		<xsl:variable name="hourLength" select="string-length($normalizedHour)"/>
		<xsl:variable name="minuteLength" select="string-length($normalizedMinute)"/>
		<xsl:variable name="secondLength" select="string-length($normalizedSecond)"/>

		<xsl:variable name="hourUnit" select="$cxsltl:date.iso8601.datetime.timeUnits/cxsltl:hour"/>
		<xsl:variable name="minuteUnit" select="$cxsltl:date.iso8601.datetime.timeUnits/cxsltl:minute"/>
		<xsl:variable name="secondUnit" select="$cxsltl:date.iso8601.datetime.timeUnits/cxsltl:second"/>

		<xsl:variable name="dateCheck">
			<xsl:call-template name="cxsltl:date.common.check">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="month" select="$month"/>
				<xsl:with-param name="day" select="$day"/>
				<xsl:with-param name="dayOfYear" select="$dayOfYear"/>
				<xsl:with-param name="week" select="$week"/>
				<xsl:with-param name="hour">
					<xsl:choose>
						<xsl:when test="floor($normalizedHour) = 24">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="floor($normalizedHour)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="minute" select="floor($normalizedMinute)"/>
				<xsl:with-param name="second" select="floor($normalizedSecond)"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="number(
			number($dateCheck) and
			(
				(string-length($year) = $cxsltl:date.iso8601.datetime.dateUnits/cxsltl:year/@length) and
				not(translate($year, '0123456789', ''))
			) and
			(
				(string-length($month) = $cxsltl:date.iso8601.datetime.dateUnits/cxsltl:month/@length) and
				not(translate($month, '0123456789', ''))
			) and
			(
				(string-length($day) = $cxsltl:date.iso8601.datetime.dateUnits/cxsltl:day/@length) and
				not(translate($day, '0123456789', ''))
			) and
			(
				(string-length($dayOfYear) = $cxsltl:date.iso8601.datetime.dateUnits/cxsltl:dayOfYear/@length) and
				not(translate($dayOfYear, '0123456789', ''))
			) and
			(
				(string-length($week) = $cxsltl:date.iso8601.datetime.dateUnits/cxsltl:week/@length) and
				not(translate($week, '0123456789', '')) and
				(
					(($year + floor($year div 4) - floor($year div 100) + floor($year div 400)) mod 7 = 4) or
					((($year - 1) + floor(($year - 1) div 4) - floor(($year - 1) div 100) + floor(($year - 1) div 400)) mod 7 = 3)
				) or $week &lt;= 52
			) and
			(
				(string-length($weekNumber) = $cxsltl:date.iso8601.datetime.dateUnits/cxsltl:weekNumber/@length) and
				not(translate($weekNumber, '0123456789', '')) and
				(1 &lt;= $weekNumber) and
				($weekNumber &lt;= 7)
			) and
			(
				($hourUnit/@length &lt;= $hourLength) and
				not(translate(substring($normalizedHour, 1, $hourUnit/@length), '0123456789', '')) and
				(($hourLength = $hourUnit/@length) or (
					(substring($normalizedHour, $hourUnit/@length + 1, 1) = '.') and
					not(translate(substring($normalizedHour, $hourUnit/@length + 2), '0123456789', ''))
				))
			) and
			(
				($minuteUnit/@length &lt;= $minuteLength) and
				not(translate(substring($normalizedMinute, 1, $minuteUnit/@length), '0123456789', '')) and
				(($minuteLength = $minuteUnit/@length) or (
					(substring($normalizedMinute, $minuteUnit/@length + 1, 1) = '.') and
					not(translate(substring($normalizedMinute, $minuteUnit/@length + 2), '0123456789', ''))
				))
			) and
			(
				($secondUnit/@length &lt;= $secondLength) and
				not(translate(substring($normalizedSecond, 1, $secondUnit/@length), '0123456789', '')) and
				(($secondLength = $secondUnit/@length) or (
					(substring($normalizedSecond, $secondUnit/@length + 1, 1) = '.') and
					not(translate(substring($normalizedSecond, $secondUnit/@length + 2), '0123456789', ''))
				))
			)
		)"/>
	</xsl:template>

	<!-- ==============================
		## Parse of Date Time
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>ISO 8601の日付形式を時間単位ごとに分割する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="ISO 8601の日付形式"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックを適用するノードセット"/>
		<xsltdoc:paramAny xsltdoc:name="param1" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param2" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param3" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param4" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param5" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:return xsltdoc:short="各時間単位を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.parse">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.print']"/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>
		<xsl:param name="param4"/>
		<xsl:param name="param5"/>

		<xsl:variable name="datetime" select="translate($string, 't,zZ', 'T.')"/>

		<xsl:variable name="date">
			<xsl:call-template name="cxsltl:string.substringBefore">
				<xsl:with-param name="string" select="translate($datetime, '-', '')"/>
				<xsl:with-param name="substring">T</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="checkCalenderDate">
			<xsl:call-template name="cxsltl:date.iso8601.datetime.checkCalenderDate">
				<xsl:with-param name="string" select="$date"/>
				<xsl:with-param name="extended" select="0"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="checkWeekDate">
			<xsl:call-template name="cxsltl:date.iso8601.datetime.checkWeekDate">
				<xsl:with-param name="string" select="$date"/>
				<xsl:with-param name="extended" select="0"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="checkOrdinalDate">
			<xsl:call-template name="cxsltl:date.iso8601.datetime.checkOrdinalDate">
				<xsl:with-param name="string" select="$date"/>
				<xsl:with-param name="extended" select="0"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="year" select="substring($date, $cxsltl:date.iso8601.datetime.dateUnits/cxsltl:year/@basicStart, $cxsltl:date.iso8601.datetime.dateUnits/cxsltl:year/@length)"/>
		<xsl:variable name="leapYear">
			<xsl:call-template name="cxsltl:date.common.isLeapYear">
				<xsl:with-param name="year" select="$year"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="monthDay">
			<xsl:choose>
				<xsl:when test="number($checkCalenderDate)">
					<xsl:variable name="calenderDate" select="concat($date, substring('00000101', string-length($date) + 1))"/>

					<xsl:value-of select="concat(
						substring(
							$calenderDate,
							$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:month/@basicStart,
							$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:month/@length
						),
						'-',
						substring(
							$calenderDate,
							$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:day/@basicStart,
							$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:day/@length
						)
					)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="cxsltl:date.common.dayOfYearToMonthDay">
						<xsl:with-param name="dayOfYear">
							<xsl:choose>
								<xsl:when test="number($checkWeekDate)">
									<xsl:variable name="weekDate" select="concat($date, substring('0000W011', string-length($date) + 1))"/>

									<xsl:call-template name="cxsltl:date.iso8601.datetime.weekToDayOfYear">
										<xsl:with-param name="year" select="$year"/>
										<xsl:with-param name="week" select="substring(
											$weekDate,
											$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:week/@basicStart,
											$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:week/@length
										)"/>
										<xsl:with-param name="weekNumber" select="substring(
											$weekDate,
											$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:weekNumber/@basicStart,
											$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:weekNumber/@length
										)"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="number($checkOrdinalDate)">
									<xsl:value-of select="substring(
										$date,
										$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:dayOfYear/@basicStart,
										$cxsltl:date.iso8601.datetime.dateUnits/cxsltl:dayOfYear/@length
									)"/>
								</xsl:when>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="leapYear" select="number($leapYear)"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="month" select="substring-before($monthDay, '-')"/>
		<xsl:variable name="day" select="substring-after($monthDay, '-')"/>

		<xsl:variable name="localtime" select="translate(substring-after($datetime, 'T'), ':', '')"/>
		<xsl:variable name="tzBefore">
			<xsl:call-template name="cxsltl:date.iso8601.datetime.timezoneBefore">
				<xsl:with-param name="string" select="$localtime"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="time" select="concat($tzBefore, substring('000000', string-length($tzBefore) + 1))"/>
		<xsl:variable name="timezone">
			<xsl:variable name="result" select="substring($localtime, string-length($tzBefore) + 1)"/>

			<xsl:value-of select="concat($result, substring('+0000', string-length($result) + 1))"/>
		</xsl:variable>

		<xsl:variable name="hour">
			<xsl:value-of select="substring(
				$time,
				$cxsltl:date.iso8601.datetime.timeUnits/cxsltl:hour/@basicStart,
				$cxsltl:date.iso8601.datetime.timeUnits/cxsltl:hour/@length
			)"/>

			<xsl:variable name="decimal" select="substring($time, $cxsltl:date.iso8601.datetime.timeUnits/cxsltl:hour/@basicStart + $cxsltl:date.iso8601.datetime.timeUnits/cxsltl:hour/@length)"/>

			<xsl:if test="starts-with($decimal, '.')">
				<xsl:value-of select="$decimal"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="minute">
			<xsl:choose>
				<xsl:when test="contains($hour, '.')">
					<xsl:value-of select="60 * ($hour mod 1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(
						$time,
						$cxsltl:date.iso8601.datetime.timeUnits/cxsltl:minute/@basicStart,
						$cxsltl:date.iso8601.datetime.timeUnits/cxsltl:minute/@length
					)"/>

					<xsl:variable name="decimal" select="substring($time, $cxsltl:date.iso8601.datetime.timeUnits/cxsltl:minute/@basicStart + $cxsltl:date.iso8601.datetime.timeUnits/cxsltl:minute/@length)"/>

					<xsl:if test="starts-with($decimal, '.')">
						<xsl:value-of select="$decimal"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="second">
			<xsl:choose>
				<xsl:when test="contains($minute, '.')">
					<xsl:value-of select="60 * ($minute mod 1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(
						$time,
						$cxsltl:date.iso8601.datetime.timeUnits/cxsltl:second/@basicStart,
						$cxsltl:date.iso8601.datetime.timeUnits/cxsltl:second/@length
					)"/>

					<xsl:variable name="decimal" select="substring($time, $cxsltl:date.iso8601.datetime.timeUnits/cxsltl:second/@basicStart + $cxsltl:date.iso8601.datetime.timeUnits/cxsltl:second/@length)"/>

					<xsl:if test="starts-with($decimal, '.')">
						<xsl:value-of select="$decimal"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="monthOfDays" select="$cxsltl:date.common.monthes[@number = number($month)]/@days + (($month = 2) and number($leapYear))"/>

		<xsl:variable name="p1" select="$hour = 24"/>
		<xsl:variable name="p2" select="$p1 and ($day = $monthOfDays)"/>
		<xsl:variable name="p3" select="$p1 and $p2 and ($month = 12)"/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="year" select="$year + $p3"/>
			<xsl:with-param name="month" select="($month + $p2) - ($month * (12 &lt; ($month + $p2)))"/>
			<xsl:with-param name="day" select="($day + $p1) - ($day * ($monthOfDays &lt; ($day + $p1)))"/>
			<xsl:with-param name="hour" select="floor($hour) mod 24"/>
			<xsl:with-param name="minute" select="floor($minute)"/>
			<xsl:with-param name="second" select="$second"/>
			<xsl:with-param name="timezoneSign" select="substring(
				$timezone,
				$cxsltl:date.iso8601.datetime.timezoneUnits/cxsltl:sign/@basicStart,
				$cxsltl:date.iso8601.datetime.timezoneUnits/cxsltl:sign/@length
			)"/>
			<xsl:with-param name="timezoneHour" select="substring(
				$timezone,
				$cxsltl:date.iso8601.datetime.timezoneUnits/cxsltl:hour/@basicStart,
				$cxsltl:date.iso8601.datetime.timezoneUnits/cxsltl:hour/@length
			)"/>
			<xsl:with-param name="timezoneMinute" select="substring(
				$timezone,
				$cxsltl:date.iso8601.datetime.timezoneUnits/cxsltl:minute/@basicStart,
				$cxsltl:date.iso8601.datetime.timezoneUnits/cxsltl:minute/@length
			)"/>
			<xsl:with-param name="param1" select="$param1"/>
			<xsl:with-param name="param2" select="$param2"/>
			<xsl:with-param name="param3" select="$param3"/>
			<xsl:with-param name="param4" select="$param4"/>
			<xsl:with-param name="param5" select="$param5"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==============================
		# Other
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>年、月、日からISO 8601の曜日番号を求める</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="year" xsltdoc:short="年"/>
		<xsltdoc:paramNumber xsltdoc:name="month" xsltdoc:short="月"/>
		<xsltdoc:paramNumber xsltdoc:name="day" xsltdoc:short="日"/>
		<xsltdoc:returnNumber xsltdoc:short="月曜日の1から日曜日の7までの数値を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.getWeekNumber">
		<xsl:param name="year" select="2000"/>
		<xsl:param name="month" select="1"/>
		<xsl:param name="day" select="1"/>

		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:date.common.getWeekNumber">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="month" select="$month"/>
				<xsl:with-param name="day" select="$day"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="(($result + 6) mod 7) + 1"/>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>ISO 8601の時間形式からタイムゾーンを除く</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="ISO 8601の日付形式"/>
		<xsltdoc:returnString xsltdoc:short="タイムゾーンを除いた時間形式を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.timezoneBefore">
		<xsl:param name="string" select="normalize-space()"/>

		<xsl:variable name="normalized" select="translate($string, 'z', 'Z')"/>

		<xsl:choose>
			<xsl:when test="contains($normalized, 'Z')">
				<xsl:value-of select="substring-before($normalized, 'Z')"/>
			</xsl:when>
			<xsl:when test="contains($normalized, '+')">
				<xsl:value-of select="substring-before($normalized, '+')"/>
			</xsl:when>
			<xsl:when test="contains($normalized, '-')">
				<xsl:value-of select="substring-before($normalized, '-')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$normalized"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>年、週、曜日番号から通算日を求める</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="year" xsltdoc:short="年"/>
		<xsltdoc:paramNumber xsltdoc:name="week" xsltdoc:short="週"/>
		<xsltdoc:paramNumber xsltdoc:name="weekNumber" xsltdoc:short="曜日番号"/>
		<xsltdoc:returnNumber xsltdoc:short="通算日を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:date.iso8601.datetime.weekToDayOfYear">
		<xsl:param name="year" select="2000"/>
		<xsl:param name="week" select="1"/>
		<xsl:param name="weekNumber" select="1"/>

		<xsl:variable name="yearStartWeekNumber">
			<xsl:call-template name="cxsltl:date.iso8601.datetime.getWeekNumber">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="day" select="4"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="($week * 7) + $weekNumber - ($yearStartWeekNumber + 3)"/>
	</xsl:template>
</xsl:stylesheet>