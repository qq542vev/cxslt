<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="string.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>行を扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-02-02</xsltdoc:version>
		<xsltdoc:since>2017-02-02</xsltdoc:since>
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

	<xsl:variable name="cxsltl:line.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>改行文字を正規化をする置換用の要素ノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:line.normalize" select="$cxsltl:line.self/cxsltl:string.search[@xml:id = 'cxsltl.line.normalize']/*"/>

	<!-- ==============================
		# cxsltl:string.search Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.line.normalize">
		<xsltdoc:short>改行文字を正規化をする置換用の要素ノード</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:string.search xml:id="cxsltl.line.normalize">
		<cxsltl:string.replace src="&#xD;&#xA;" dst="&#xA;"/>
		<cxsltl:string.replace src="&#xD;&#x85;" dst="&#xA;"/>
		<cxsltl:string.replace src="&#x85;" dst="&#xA;"/>
		<cxsltl:string.replace src="&#x2028;" dst="&#xA;"/>
		<cxsltl:string.replace src="&#xD;" dst="&#xA;"/>
	</cxsltl:string.search>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列の行数を求める</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is 4</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.lineCount">
					<xsl:with-param name="string">a&#xA;b&#xD;c&#xD;&#xA;</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-01-11</xsltdoc:version>
		<xsltdoc:since>2014-12-24</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="行数を求める文字列"/>
		<xsltdoc:returnNumber xsltdoc:short="行数"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:line.count">
		<xsl:param name="string" select="."/>

		<xsl:variable name="count">
			<xsl:call-template name="cxsltl:string.substringCount">
				<xsl:with-param name="string">
					<xsl:call-template name="cxsltl:line.normalize">
						<xsl:with-param name="string" select="$string"/>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="substring" select="'&#xA;'"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="$count + 1"/>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列を行で分割し、コールバックテンプレートを呼び出す</xsltdoc:short>
		<xsltdoc:version>2015-01-11</xsltdoc:version>
		<xsltdoc:since>2015-01-01</xsltdoc:since>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックを適用するノードセット"/>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="分割する文字列"/>
		<xsltdoc:paramAny xsltdoc:name="param1" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param2" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param3" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param4" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param5" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:return xsltdoc:short="コールバックテンプレートから返ってきた値をそのまま返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:line.split">
		<xsl:param name="callback" select="$cxsltl:string.self/xsl:template[@name = 'cxsltl:string.callback.split']"/>
		<xsl:param name="string" select="."/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>
		<xsl:param name="param4"/>
		<xsl:param name="param5"/>

		<xsl:call-template name="cxsltl:string.split">
			<xsl:with-param name="callback" select="$callback"/>
			<xsl:with-param name="string">
				<xsl:call-template name="cxsltl:line.normalize">
					<xsl:with-param name="string" select="$string"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="delimiter" select="'&#xA;'"/>
			<xsl:with-param name="param1" select="$param1"/>
			<xsl:with-param name="param2" select="$param2"/>
			<xsl:with-param name="param3" select="$param3"/>
			<xsl:with-param name="param4" select="$param4"/>
			<xsl:with-param name="param5" select="$param5"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>改行文字を正規化する</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is a&#xA;b&#xA;c&#xA;</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:line.normalize">
					<xsl:with-param name="string">a&#xA;b&#xD;c&#xD;&#xA;</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is a&#xD;b&#xD;c&#xD;</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:line.normalize">
					<xsl:with-param name="string">a&#xA;b&#xD;c&#xD;&#xA;</xsl:with-param>
					<xsl:with-param name="eol" select="'&#xD;'"/>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-01-11</xsltdoc:version>
		<xsltdoc:since>2014-12-28</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="正規化する文字列"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行コード"/>
		<xsltdoc:returnString xsltdoc:short="改行コードが正規化された文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:line.normalize">
		<xsl:param name="string" select="."/>
		<xsl:param name="eol" select="'&#xA;'"/>

		<xsl:call-template name="cxsltl:string.replace">
			<xsl:with-param name="string">
				<xsl:call-template name="cxsltl:string.multipleReplace">
					<xsl:with-param name="node" select="$cxsltl:line.normalize"/>
					<xsl:with-param name="string" select="$string"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="src" select="'&#xA;'"/>
			<xsl:with-param name="dst" select="$eol"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>$stringに行番号を付ける</xsltdoc:short>
		<xsltdoc:version>2017-04-07</xsltdoc:version>
		<xsltdoc:since>2017-04-07</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="行番号を付ける文字列"/>
		<xsltdoc:paramString xsltdoc:name="format" xsltdoc:short="行番号の形式"/>
		<xsltdoc:paramNumber xsltdoc:name="start" xsltdoc:short="行番号の初期値"/>
		<xsltdoc:paramNumber xsltdoc:name="increment" xsltdoc:short="行番号の加算値"/>
		<xsltdoc:paramString xsltdoc:name="prefix" xsltdoc:short="行の接頭辞"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行コード"/>
		<xsltdoc:returnString xsltdoc:short="行番号付けされた文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:line.number">
		<xsl:param name="string" select="."/>
		<xsl:param name="format">rn</xsl:param>
		<xsl:param name="start" select="1"/>
		<xsl:param name="increment" select="1"/>
		<xsl:param name="prefix"> | </xsl:param>
		<xsl:param name="eol" select="'&#xA;'"/>

		<xsl:call-template name="cxsltl:line.split">
			<xsl:with-param name="callback" select="$cxsltl:line.self/xsl:template[@name = 'cxsltl:line.number']"/>
			<xsl:with-param name="string" select="$string"/>
			<xsl:with-param name="param1" select="$format"/>
			<xsl:with-param name="param2" select="$start"/>
			<xsl:with-param name="param3" select="$increment"/>
			<xsl:with-param name="param4" select="$prefix"/>
			<xsl:with-param name="param5" select="$eol"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>$formatによる数値形式を生成する</xsltdoc:short>
		<xsltdoc:version>2017-05-07</xsltdoc:version>
		<xsltdoc:since>2017-05-07</xsltdoc:since>
		<xsltdoc:paramNumber xsltdoc:name="number" xsltdoc:short="数値"/>
		<xsltdoc:paramString xsltdoc:name="format" xsltdoc:short="数値の形式"/>
		<xsltdoc:paramNumber xsltdoc:name="width" xsltdoc:short="数値の横幅"/>
		<xsltdoc:paramNumber xsltdoc:name="zeroWidth" xsltdoc:short="数値の小数点以下の横幅"/>
		<xsltdoc:returnString xsltdoc:short="$formatによる数値形式"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:line.numberFormat">
		<xsl:param name="number" select="."/>
		<xsl:param name="format">rn</xsl:param>
		<xsl:param name="width" select="string-length($number)"/>
		<xsl:param name="zeroWidth" select="0"/>

		<xsl:choose>
			<xsl:when test="$format = 'rn' or $format = 'rz' or $format = 'ln'">
				<xsl:variable name="indentCount" select="$width - string-length(floor($number))"/>

				<xsl:choose>
					<xsl:when test="$format = 'rn'">
						<xsl:value-of select="substring('                              ', 1, $indentCount)"/>
					</xsl:when>
					<xsl:when test="$format = 'rz'">
						<xsl:value-of select="substring('000000000000000000000000000000', 1, $indentCount)"/>
					</xsl:when>
				</xsl:choose>

				<xsl:value-of select="$number"/>

				<xsl:if test="0 &lt; $zeroWidth">
					<xsl:if test="$number mod 1 = 0">.</xsl:if>

					<xsl:value-of select="substring('000000000000000000000000000000', 1, $zeroWidth)"/>
				</xsl:if>

				<xsl:if test="$format = 'ln'">
					<xsl:value-of select="substring('                              ', 1, $indentCount)"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number($number, $format)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>cxsltl:line.numberのコールバックテンプレート</xsltdoc:short>
		<xsltdoc:version>2017-05-07</xsltdoc:version>
		<xsltdoc:since>2017-04-07</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="行番号を付ける文字列"/>
		<xsltdoc:paramNumber xsltdoc:name="count" xsltdoc:short="総行数"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="現在の行数"/>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="行番号を付ける文字列"/>
		<xsltdoc:paramString xsltdoc:name="param1" xsltdoc:short="行番号の形式"/>
		<xsltdoc:paramNumber xsltdoc:name="param2" xsltdoc:short="行番号の初期値"/>
		<xsltdoc:paramNumber xsltdoc:name="param3" xsltdoc:short="行番号の加算値"/>
		<xsltdoc:paramString xsltdoc:name="param4" xsltdoc:short="行の接頭辞"/>
		<xsltdoc:paramString xsltdoc:name="param5" xsltdoc:short="行の接尾辞"/>
		<xsltdoc:returnString xsltdoc:short="行番号付けされた文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:line.number']" mode="cxsltl:callback" name="cxsltl:line.callback.number">
		<xsl:param name="string"/>
		<xsl:param name="count"/>
		<xsl:param name="position"/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>
		<xsl:param name="param4"/>
		<xsl:param name="param5"/>

		<xsl:variable name="number" select="$param2 + (($position - 1) * $param3)"/>

		<xsl:call-template name="cxsltl:line.numberFormat">
			<xsl:with-param name="number" select="$number"/>
			<xsl:with-param name="format" select="$param1"/>
			<xsl:with-param name="width" select="string-length(floor($param2 + (($count - 1) * $param3)))"/>
			<xsl:with-param name="zeroWidth" select="string-length(substring-after($param3, '.')) - string-length(substring-after($number, '.'))"/>
		</xsl:call-template>

		<xsl:value-of select="concat($param4, $string)"/>

		<xsl:if test="$position != $count">
			<xsl:value-of select="$param5"/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>