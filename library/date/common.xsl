<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../common.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>日付を扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-27</xsltdoc:version>
		<xsltdoc:since>2017-09-27</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:date.common.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>各時間単位</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:date.common.units" select="$cxsltl:date.common.self/cxsltl:units[@xml:id = 'cxsltl.date.common.units']"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>各月</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:date.common.monthes" select="$cxsltl:date.common.self/cxsltl:monthes[@xml:id = 'cxsltl.date.common.monthes']/cxsltl:monthe"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>各曜日</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:date.common.weeks" select="$cxsltl:date.common.self/cxsltl:weeks[@xml:id = 'cxsltl.date.common.weeks']/cxsltl:week"/>

	<!-- ==============================
		# Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.date.common.units">
		<xsltdoc:short>各時間単位</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:units xml:id="cxsltl.date.common.units">
		<cxsltl:year name="Year"/>
		<cxsltl:month name="Month" min="1" max="12"/>
		<cxsltl:day name="Day" min="1" max="31" second="86400"/>
		<cxsltl:dayOfYear name="Day of year" min="1" max="366" second="86400"/>
		<cxsltl:week name="Week" min="1" max="53" second="604800"/>
		<cxsltl:weekNumber name="Week number" min="0" max="6" second="86400"/>
		<cxsltl:hour name="Hour" min="0" max="23" second="3600"/>
		<cxsltl:minute name="Minute" min="0" max="59" second="60"/>
		<cxsltl:second name="Second" min="0" max="60" second="1"/>
	</cxsltl:units>

	<xsltdoc:Element rdf:about="#cxsltl.date.common.monthes">
		<xsltdoc:short>各月</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:monthes xml:id="cxsltl.date.common.monthes">
		<cxsltl:monthe number="1" name="January" abbr="Jan" days="31" beforeTotalDays="0"/>
		<cxsltl:monthe number="2" name="February" abbr="Feb" days="28" beforeTotalDays="31"/>
		<cxsltl:monthe number="3" name="March" abbr="Mar" days="31" beforeTotalDays="59"/>
		<cxsltl:monthe number="4" name="April" abbr="Apr" days="30" beforeTotalDays="90"/>
		<cxsltl:monthe number="5" name="May" abbr="May" days="31" beforeTotalDays="120"/>
		<cxsltl:monthe number="6" name="June" abbr="Jun" days="30" beforeTotalDays="151"/>
		<cxsltl:monthe number="7" name="July" abbr="Jul" days="31" beforeTotalDays="181"/>
		<cxsltl:monthe number="8" name="August" abbr="Aug" days="31" beforeTotalDays="212"/>
		<cxsltl:monthe number="9" name="September" abbr="Sep" days="30" beforeTotalDays="243"/>
		<cxsltl:monthe number="10" name="October" abbr="Oct" days="31" beforeTotalDays="273"/>
		<cxsltl:monthe number="11" name="November" abbr="Nov" days="30" beforeTotalDays="304"/>
		<cxsltl:monthe number="12" name="December" abbr="Dec" days="31" beforeTotalDays="334"/>
	</cxsltl:monthes>

	<xsltdoc:Element rdf:about="#cxsltl.date.common.weeks">
		<xsltdoc:short>各曜日</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:weeks xml:id="cxsltl.date.common.weeks">
		<cxsltl:week number="0" isoWeekNumber="7" name="Sunday" abbr="Sun"/>
		<cxsltl:week number="1" isoWeekNumber="1" name="Monday" abbr="Mon"/>
		<cxsltl:week number="2" isoWeekNumber="2" name="Tuesday" abbr="Tue"/>
		<cxsltl:week number="3" isoWeekNumber="3" name="Wednesday" abbr="Wed"/>
		<cxsltl:week number="4" isoWeekNumber="4" name="Thursday" abbr="Thu"/>
		<cxsltl:week number="5" isoWeekNumber="5" name="Friday" abbr="Fri"/>
		<cxsltl:week number="6" isoWeekNumber="6" name="Saturday" abbr="Sat"/>
	</cxsltl:weeks>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>年、月、日から曜日番号を求める</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="year" xsltdoc:short="年"/>
		<xsltdoc:paramNumber xsltdoc:name="month" xsltdoc:short="月"/>
		<xsltdoc:paramNumber xsltdoc:name="day" xsltdoc:short="日"/>
		<xsltdoc:paramBoolean xsltdoc:name="gregorian" xsltdoc:short="グレゴリオ暦で計算するか"/>
		<xsltdoc:returnNumber xsltdoc:short="日曜日の0から土曜日の6までの数値を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:date.common.getWeekNumber']" mode="cxsltl:callback" name="cxsltl:date.common.getWeekNumber">
		<xsl:param name="year" select="2000"/>
		<xsl:param name="month" select="1"/>
		<xsl:param name="day" select="1"/>
		<xsl:param name="gregorian" select="true()"/>

		<xsl:variable name="_year" select="$year - ($month &lt;= 2)"/>
		<xsl:variable name="_month" select="$month + (($month &lt;= 2) * 12)"/>

		<xsl:choose>
			<xsl:when test="$gregorian">
				<xsl:value-of select="($_year + floor($_year div 4) - floor($_year div 100) + floor($_year div 400) + floor((13 * $_month + 8) div 5) + $day) mod 7"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="($_year + floor($_year div 4) + floor((13 * $_month + 8) div 5) + $day + 5) mod 7"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>閏年か調べる</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="year" xsltdoc:short="年"/>
		<xsltdoc:paramBoolean xsltdoc:name="gregorian" xsltdoc:short="グレゴリオ暦で計算するか"/>
		<xsltdoc:returnBoolean xsltdoc:short="閏年ならば1を、それ以外ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:date.common.isLeapYear']" mode="cxsltl:callback" name="cxsltl:date.common.isLeapYear">
		<xsl:param name="year" select="2000"/>
		<xsl:param name="gregorian" select="true()"/>

		<xsl:choose>
			<xsl:when test="$gregorian">
				<xsl:value-of select="number(($year mod 4 = 0) and (($year mod 100 != 0) or ($year mod 400 = 0)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number($year mod 4 = 0)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>各時間単位を出力する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="year" xsltdoc:short="年"/>
		<xsltdoc:paramNumber xsltdoc:name="month" xsltdoc:short="月"/>
		<xsltdoc:paramNumber xsltdoc:name="day" xsltdoc:short="日"/>
		<xsltdoc:paramNumber xsltdoc:name="hour" xsltdoc:short="時"/>
		<xsltdoc:paramNumber xsltdoc:name="minute" xsltdoc:short="分"/>
		<xsltdoc:paramNumber xsltdoc:name="second" xsltdoc:short="秒"/>
		<xsltdoc:paramString xsltdoc:name="timezoneSign" xsltdoc:short="+ または -"/>
		<xsltdoc:paramNumber xsltdoc:name="timezoneHour" xsltdoc:short="UTCからのオフセット時"/>
		<xsltdoc:paramNumber xsltdoc:name="timezoneMinute" xsltdoc:short="UTCからのオフセット分"/>
		<xsltdoc:paramNumber xsltdoc:name="timezoneSecond" xsltdoc:short="UTCからのオフセット秒"/>
		<xsltdoc:returnString xsltdoc:short="E-Mailの日付形式を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:date.common.print']" mode="cxsltl:callback" name="cxsltl:date.common.print">
		<xsl:param name="year" select="2000"/>
		<xsl:param name="month" select="1"/>
		<xsl:param name="day" select="1"/>
		<xsl:param name="hour" select="0"/>
		<xsl:param name="minute" select="0"/>
		<xsl:param name="second" select="0"/>
		<xsl:param name="timezoneSign">+</xsl:param>
		<xsl:param name="timezoneHour" select="0"/>
		<xsl:param name="timezoneMinute" select="0"/>
		<xsl:param name="timezoneSecond" select="0"/>

		<xsl:value-of select="concat('year ', format-number($year, '#0000', 'cxsltl:common.numberFormat'), '&#xA;')"/>
		<xsl:value-of select="concat('month ', format-number($month, '00', 'cxsltl:common.numberFormat'), '&#xA;')"/>
		<xsl:value-of select="concat('day ', format-number($day, '00', 'cxsltl:common.numberFormat'), '&#xA;')"/>
		<xsl:value-of select="concat('hour ', format-number($hour, '00', 'cxsltl:common.numberFormat'), '&#xA;')"/>
		<xsl:value-of select="concat('minute ', format-number($minute, '00', 'cxsltl:common.numberFormat'), '&#xA;')"/>
		<xsl:value-of select="concat('second ', format-number($second, '00.##############################', 'cxsltl:common.numberFormat'), '&#xA;')"/>
		<xsl:value-of select="concat('timezoneSign ', $timezoneSign, '&#xA;')"/>
		<xsl:value-of select="concat('timezoneHour ', format-number($timezoneHour, '00', 'cxsltl:common.numberFormat'), '&#xA;')"/>
		<xsl:value-of select="concat('timezoneMinute ', format-number($timezoneMinute, '00', 'cxsltl:common.numberFormat'), '&#xA;')"/>
		<xsl:value-of select="concat('timezoneSecond ', format-number($timezoneSecond, '00', 'cxsltl:common.numberFormat'), '&#xA;')"/>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>各時間単位をE-Mailの日付形式に変換する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="year" xsltdoc:short="年"/>
		<xsltdoc:paramNumber xsltdoc:name="month" xsltdoc:short="月"/>
		<xsltdoc:paramNumber xsltdoc:name="day" xsltdoc:short="日"/>
		<xsltdoc:paramNumber xsltdoc:name="hour" xsltdoc:short="時"/>
		<xsltdoc:paramNumber xsltdoc:name="minute" xsltdoc:short="分"/>
		<xsltdoc:paramNumber xsltdoc:name="second" xsltdoc:short="秒"/>
		<xsltdoc:paramString xsltdoc:name="timezoneSign" xsltdoc:short="+ または -"/>
		<xsltdoc:paramNumber xsltdoc:name="timezoneHour" xsltdoc:short="UTCからのオフセット時"/>
		<xsltdoc:paramNumber xsltdoc:name="timezoneMinute" xsltdoc:short="UTCからのオフセット分"/>
		<xsltdoc:returnString xsltdoc:short="E-Mailの日付形式を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:date.common.toEmailDateTime']" mode="cxsltl:callback" name="cxsltl:date.common.toEmailDateTime">
		<xsl:param name="year" select="2000"/>
		<xsl:param name="month" select="1"/>
		<xsl:param name="day" select="1"/>
		<xsl:param name="hour" select="0"/>
		<xsl:param name="minute" select="0"/>
		<xsl:param name="second" select="0"/>
		<xsl:param name="timezoneSign">+</xsl:param>
		<xsl:param name="timezoneHour" select="0"/>
		<xsl:param name="timezoneMinute" select="0"/>

		<xsl:variable name="weekNumber">
			<xsl:call-template name="cxsltl:date.common.getWeekNumber">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="month" select="$month"/>
				<xsl:with-param name="day" select="$day"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="concat(
			$cxsltl:date.common.weeks[@number = $weekNumber]/@abbr, ', ',
			format-number($day, '00', 'cxsltl:common.numberFormat'), ' ', $cxsltl:date.common.monthes[@number = number($month)]/@abbr, ' ', format-number($year, '0000', 'cxsltl:common.numberFormat'),
			' ', format-number($hour, '00', 'cxsltl:common.numberFormat'), ':', format-number($minute, '00', 'cxsltl:common.numberFormat'), ':', format-number($second, '00', 'cxsltl:common.numberFormat'),
			' ', $timezoneSign, format-number($timezoneHour, '00', 'cxsltl:common.numberFormat'), format-number($timezoneMinute, '00', 'cxsltl:common.numberFormat')
		)"/>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>各時間単位をISO 8601の日付形式に変換する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="year" xsltdoc:short="年"/>
		<xsltdoc:paramNumber xsltdoc:name="month" xsltdoc:short="月"/>
		<xsltdoc:paramNumber xsltdoc:name="day" xsltdoc:short="日"/>
		<xsltdoc:paramNumber xsltdoc:name="hour" xsltdoc:short="時"/>
		<xsltdoc:paramNumber xsltdoc:name="minute" xsltdoc:short="分"/>
		<xsltdoc:paramNumber xsltdoc:name="second" xsltdoc:short="秒"/>
		<xsltdoc:paramString xsltdoc:name="timezoneSign" xsltdoc:short="+ または -"/>
		<xsltdoc:paramNumber xsltdoc:name="timezoneHour" xsltdoc:short="UTCからのオフセット時"/>
		<xsltdoc:paramNumber xsltdoc:name="timezoneMinute" xsltdoc:short="UTCからのオフセット分"/>
		<xsltdoc:paramBoolean xsltdoc:name="extended" xsltdoc:short="変換した日付形式を拡張形式とするか"/>
		<xsltdoc:returnString xsltdoc:short="ISO 8601の日付形式を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:date.common.toIso8601DateTime']" mode="cxsltl:callback" name="cxsltl:date.common.toIso8601DateTime">
		<xsl:param name="year" select="2000"/>
		<xsl:param name="month" select="1"/>
		<xsl:param name="day" select="1"/>
		<xsl:param name="hour" select="0"/>
		<xsl:param name="minute" select="0"/>
		<xsl:param name="second" select="0"/>
		<xsl:param name="timezoneSign">+</xsl:param>
		<xsl:param name="timezoneHour" select="0"/>
		<xsl:param name="timezoneMinute" select="0"/>
		<xsl:param name="extended" select="true()"/>

		<xsl:variable name="dateSep" select="substring('-', 1, $extended)"/>
		<xsl:variable name="timeSep" select="substring(':', 1, $extended)"/>

		<xsl:value-of select="concat(
			format-number($year, '0000', 'cxsltl:common.numberFormat'),
			$dateSep,
			format-number($month, '00', 'cxsltl:common.numberFormat'),
			$dateSep,
			format-number($day, '00', 'cxsltl:common.numberFormat'),
			'T',
			format-number($hour, '00', 'cxsltl:common.numberFormat'),
			$timeSep,
			format-number($minute, '00', 'cxsltl:common.numberFormat'),
			$timeSep,
			format-number($second, '00.##############################', 'cxsltl:common.numberFormat'),
			$timezoneSign,
			format-number($timezoneHour, '00', 'cxsltl:common.numberFormat'),
			$timeSep,
			format-number($timezoneMinute, '00', 'cxsltl:common.numberFormat')
		)"/>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>各時間単位を修正ユリウス日に変換する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="year" xsltdoc:short="年"/>
		<xsltdoc:paramNumber xsltdoc:name="month" xsltdoc:short="月"/>
		<xsltdoc:paramNumber xsltdoc:name="day" xsltdoc:short="日"/>
		<xsltdoc:paramNumber xsltdoc:name="hour" xsltdoc:short="時"/>
		<xsltdoc:paramNumber xsltdoc:name="minute" xsltdoc:short="分"/>
		<xsltdoc:paramNumber xsltdoc:name="second" xsltdoc:short="秒"/>
		<xsltdoc:paramString xsltdoc:name="timezoneSign" xsltdoc:short="+ または -"/>
		<xsltdoc:paramNumber xsltdoc:name="timezoneHour" xsltdoc:short="UTCからのオフセット時"/>
		<xsltdoc:paramNumber xsltdoc:name="timezoneMinute" xsltdoc:short="UTCからのオフセット分"/>
		<xsltdoc:paramNumber xsltdoc:name="timezoneSecond" xsltdoc:short="UTCからのオフセット秒"/>
		<xsltdoc:paramBoolean xsltdoc:name="gregorian" xsltdoc:short="グレゴリオ暦で計算するか"/>
		<xsltdoc:returnNumber xsltdoc:short="修正ユリウス日を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:date.common.toModifiedJulianDate']" mode="cxsltl:callback" name="cxsltl:date.common.toModifiedJulianDate">
		<xsl:param name="year" select="2000"/>
		<xsl:param name="month" select="1"/>
		<xsl:param name="day" select="1"/>
		<xsl:param name="hour" select="0"/>
		<xsl:param name="minute" select="0"/>
		<xsl:param name="second" select="0"/>
		<xsl:param name="timezoneSign">+</xsl:param>
		<xsl:param name="timezoneHour" select="0"/>
		<xsl:param name="timezoneMinute" select="0"/>
		<xsl:param name="timezoneSecond" select="0"/>
		<xsl:param name="gregorian" select="true()"/>

		<xsl:variable name="_year" select="$year - ($month &lt;= 2)"/>
		<xsl:variable name="_month" select="$month + (($month &lt;= 2) * 12)"/>

		<xsl:variable name="time" select="
			($hour div 24) + ($minute div 1440) +(($second - (60 &lt;= $second)) div 86400) +
			(
				(($timezoneHour div 24) + ($timezoneMinute div 1440) + ($timezoneSecond div 86400)) *
				(($timezoneSign = '-') - ($timezoneSign = '+'))
			)
		"/>

		<xsl:choose>
			<xsl:when test="$gregorian">
				<xsl:value-of select="
					floor(365.25 * $_year) +
					floor($_year div 400) -
					floor($_year div 100) +
					floor(30.59 * ($_month - 2)) +
					$day - 678912 + $time
				"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="floor(365.25 * $_year) + floor(30.59 * ($_month - 2)) + $day - 678914 + $time"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>各時間単位をUnix Timeに変換する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="year" xsltdoc:short="年"/>
		<xsltdoc:paramNumber xsltdoc:name="month" xsltdoc:short="月"/>
		<xsltdoc:paramNumber xsltdoc:name="day" xsltdoc:short="日"/>
		<xsltdoc:paramNumber xsltdoc:name="hour" xsltdoc:short="時"/>
		<xsltdoc:paramNumber xsltdoc:name="minute" xsltdoc:short="分"/>
		<xsltdoc:paramNumber xsltdoc:name="second" xsltdoc:short="秒"/>
		<xsltdoc:paramString xsltdoc:name="timezoneSign" xsltdoc:short="+ または -"/>
		<xsltdoc:paramNumber xsltdoc:name="timezoneHour" xsltdoc:short="UTCからのオフセット時"/>
		<xsltdoc:paramNumber xsltdoc:name="timezoneMinute" xsltdoc:short="UTCからのオフセット分"/>
		<xsltdoc:paramNumber xsltdoc:name="timezoneSecond" xsltdoc:short="UTCからのオフセット秒"/>
		<xsltdoc:returnNumber xsltdoc:short="Unix Timeを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:date.common.toUnixTime']" mode="cxsltl:callback" name="cxsltl:date.common.toUnixTime">
		<xsl:param name="year" select="1970"/>
		<xsl:param name="month" select="1"/>
		<xsl:param name="day" select="1"/>
		<xsl:param name="hour" select="0"/>
		<xsl:param name="minute" select="0"/>
		<xsl:param name="second" select="0"/>
		<xsl:param name="timezoneSign">+</xsl:param>
		<xsl:param name="timezoneHour" select="0"/>
		<xsl:param name="timezoneMinute" select="0"/>
		<xsl:param name="timezoneSecond" select="0"/>

		<xsl:variable name="mjd">
			<xsl:call-template name="cxsltl:date.common.toModifiedJulianDate">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="month" select="$month"/>
				<xsl:with-param name="day" select="$day"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="
			(
				(($mjd - 40587) * 86400) +
				($hour * 3600) + ($minute * 60) + $second - (60 &lt;= $second)
			) + (
				(($timezoneHour * 3600) + ($timezoneMinute * 60) + $timezoneSecond) *
				(($timezoneSign = '-') - ($timezoneSign = '+'))
			)
		"/>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>月、日から通算日を求める</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="month" xsltdoc:short="月"/>
		<xsltdoc:paramNumber xsltdoc:name="day" xsltdoc:short="日"/>
		<xsltdoc:paramBoolean xsltdoc:name="leapYear" xsltdoc:short="閏年か"/>
		<xsltdoc:returnNumber xsltdoc:short="通算日を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:date.common.monthDayToDayOfYear']" mode="cxsltl:callback" name="cxsltl:date.common.monthDayToDayOfYear">
		<xsl:param name="month" select="1"/>
		<xsl:param name="day" select="1"/>
		<xsl:param name="leapYear" select="false()"/>

		<xsl:value-of select="$cxsltl:date.common.monthes[@number = number($month)]/@beforeTotalDays + $day + ($leapYear and (2 &lt; $month))"/>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>通算日から月、日を求める</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="dayOfYear" xsltdoc:short="月"/>
		<xsltdoc:paramBoolean xsltdoc:name="leapYear" xsltdoc:short="閏年か"/>
		<xsltdoc:returnString xsltdoc:short="月日を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:date.common.dayOfYearToMonthDay']" mode="cxsltl:callback" name="cxsltl:date.common.dayOfYearToMonthDay">
		<xsl:param name="dayOfYear" select="1"/>
		<xsl:param name="leapYear" select="false()"/>

		<xsl:variable name="month" select="$cxsltl:date.common.monthes[(@beforeTotalDays + ($leapYear and (2 &lt; @number))) &lt; $dayOfYear][last()]"/>

		<xsl:value-of select="concat($month/@number, '-', $dayOfYear - $month/@beforeTotalDays - ($leapYear and (2 &lt; $month/@number)))"/>
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

	<xsl:template match="xsl:template[@name = 'cxsltl:date.common.check']" mode="cxsltl:callback" name="cxsltl:date.common.check">
		<xsl:param name="year" select="2000"/>
		<xsl:param name="month" select="1"/>
		<xsl:param name="day" select="1"/>
		<xsl:param name="dayOfYear" select="1"/>
		<xsl:param name="week" select="1"/>
		<xsl:param name="weekNumber" select="0"/>
		<xsl:param name="hour" select="0"/>
		<xsl:param name="minute" select="0"/>
		<xsl:param name="second" select="0"/>

		<xsl:variable name="leapYear">
			<xsl:call-template name="cxsltl:date.common.isLeapYear">
				<xsl:with-param name="year" select="$year"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="_second" select="floor($second)"/>

		<xsl:value-of select="number(
			($year mod 1 = 0) and
			(
				($month mod 1 = 0) and
				($cxsltl:date.common.units/cxsltl:month/@min &lt;= $month) and
				($month &lt;= $cxsltl:date.common.units/cxsltl:month/@max)
			) and
			(
				($day mod 1 = 0) and
				($cxsltl:date.common.units/cxsltl:day/@min &lt;= $day) and
				($day &lt;= $cxsltl:date.common.units/cxsltl:day/@max) and
				($day &lt;= ($cxsltl:date.common.monthes[@number = number($month)]/@days + (number($leapYear) and $month = 2)))
			) and
			(
				($dayOfYear mod 1 = 0) and
				($cxsltl:date.common.units/cxsltl:dayOfYear/@min &lt;= $dayOfYear) and
				($dayOfYear &lt;= ($cxsltl:date.common.units/cxsltl:dayOfYear/@max - number(not(number($leapYear)))))
			) and
			(
				($week mod 1 = 0) and
				($cxsltl:date.common.units/cxsltl:week/@min &lt;= $week) and
				($week &lt;= $cxsltl:date.common.units/cxsltl:week/@max)
			) and
			(
				($weekNumber mod 1 = 0) and
				($cxsltl:date.common.units/cxsltl:weekNumber/@min &lt;= $weekNumber) and
				($weekNumber &lt;= $cxsltl:date.common.units/cxsltl:weekNumber/@max)
			) and
			(
				($hour mod 1 = 0) and
				($cxsltl:date.common.units/cxsltl:hour/@min &lt;= $hour) and
				($hour &lt;= $cxsltl:date.common.units/cxsltl:hour/@max)
			) and
			(
				($minute mod 1 = 0) and
				($cxsltl:date.common.units/cxsltl:minute/@min &lt;= $minute) and
				($minute &lt;= $cxsltl:date.common.units/cxsltl:minute/@max)
			) and
			(
				($cxsltl:date.common.units/cxsltl:second/@min &lt;= $_second) and
				($_second &lt;= $cxsltl:date.common.units/cxsltl:second/@max) and
				(($_second != 60) or (
					(($month = 6) and ($day = 30)) or
					(($month = 7) and ($day = 1)) or
					(($month = 12) and ($day = 31)) or
					(($month = 1) and ($day = 1))
				))
			)
		)"/>
	</xsl:template>
</xsl:stylesheet>