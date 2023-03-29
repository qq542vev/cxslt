<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../string.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>JSONを扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-04-15</xsltdoc:version>
		<xsltdoc:since>2015-01-21</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="https://www.ietf.org/rfc/rfc7159.txt"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>配列を作成する</xsltdoc:short>
		<xsltdoc:version>2017-06-02</xsltdoc:version>
		<xsltdoc:since>2017-06-02</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行文字"/>
		<xsltdoc:paramBoolean xsltdoc:name="last" xsltdoc:short="false()ならば末尾にカンマを生成する"/>
		<xsltdoc:paramString xsltdoc:name="prefix" xsltdoc:short="接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="JSONの配列を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:json.generate.array">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="indent" select="'&#x9;'"/>
		<xsl:param name="eol" select="'&#xA;'"/>
		<xsl:param name="last" select="false()"/>
		<xsl:param name="prefix">
			<xsl:call-template name="cxsltl:json.generate.prefix">
				<xsl:with-param name="key" select="$key"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
		</xsl:param>

		<xsl:variable name="trimed">
			<xsl:call-template name="cxsltl:json.generate.trim">
				<xsl:with-param name="string" select="$value"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="indents">
			<xsl:if test="string($trimed)">
				<xsl:value-of select="$eol"/>

				<xsl:call-template name="cxsltl:json.generate.indentRepeat">
					<xsl:with-param name="indent" select="$indent"/>
					<xsl:with-param name="depth" select="$depth"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>

		<xsl:value-of select="concat($prefix, '[', $indents)"/>

		<xsl:if test="string($trimed)">
			<xsl:value-of select="$indent"/>
		</xsl:if>

		<xsl:value-of select="concat($trimed, $indents, ']')"/>

		<xsl:if test="not($last)">
			<xsl:value-of select="concat(',', $eol)"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>リテラルか文字列を作成する</xsltdoc:short>
		<xsltdoc:version>2017-06-02</xsltdoc:version>
		<xsltdoc:since>2017-06-02</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行文字"/>
		<xsltdoc:paramBoolean xsltdoc:name="last" xsltdoc:short="false()ならば末尾にカンマを生成する"/>
		<xsltdoc:paramString xsltdoc:name="prefix" xsltdoc:short="接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="JSONのリテラルか文字列を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:json.generate.auto">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="indent" select="'&#x9;'"/>
		<xsl:param name="eol" select="'&#xA;'"/>
		<xsl:param name="last" select="false()"/>
		<xsl:param name="prefix">
			<xsl:call-template name="cxsltl:json.generate.prefix">
				<xsl:with-param name="key" select="$key"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
		</xsl:param>

		<xsl:call-template name="cxsltl:json.generate.contener">
			<xsl:with-param name="value" select="$value"/>
			<xsl:with-param name="type">
				<xsl:choose>
					<xsl:when test="string(number($value)) != 'NaN' or $value = 'true' or $value = 'false' or $value = 'null'">literal</xsl:when>
					<xsl:otherwise>string</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="eol" select="$eol"/>
			<xsl:with-param name="last" select="$last"/>
			<xsl:with-param name="prefix" select="$prefix"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>JSONを作成する</xsltdoc:short>
		<xsltdoc:version>2017-06-02</xsltdoc:version>
		<xsltdoc:since>2017-06-02</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:paramString xsltdoc:name="type" xsltdoc:short="$valueの型"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行文字"/>
		<xsltdoc:paramBoolean xsltdoc:name="last" xsltdoc:short="false()ならば末尾にカンマを生成する"/>
		<xsltdoc:paramBooleanString xsltdoc:name="wrap" xsltdoc:short="true()ならば配列かオブジェクトで包む"/>
		<xsltdoc:paramString xsltdoc:name="prefix" xsltdoc:short="接頭辞"/>
		<xsltdoc:paramString xsltdoc:name="value1" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key1" xsltdoc:short="$value1のキーとなる文字列"/>
		<xsltdoc:paramString xsltdoc:name="type1" xsltdoc:short="$value1の型"/>
		<xsltdoc:paramString xsltdoc:name="value2" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key2" xsltdoc:short="$value2のキーとなる文字列"/>
		<xsltdoc:paramString xsltdoc:name="type2" xsltdoc:short="$value2の型"/>
		<xsltdoc:paramString xsltdoc:name="value3" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key3" xsltdoc:short="$value3のキーとなる文字列"/>
		<xsltdoc:paramString xsltdoc:name="type3" xsltdoc:short="$value3の型"/>
		<xsltdoc:returnString xsltdoc:short="JSONを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:json.generate.contener">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>
		<xsl:param name="type">string</xsl:param>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="indent" select="'&#x9;'"/>
		<xsl:param name="eol" select="'&#xA;'"/>
		<xsl:param name="last" select="false()"/>
		<xsl:param name="wrap" select="false()"/>
		<xsl:param name="prefix">
			<xsl:call-template name="cxsltl:json.generate.prefix">
				<xsl:with-param name="key">
					<xsl:choose>
						<xsl:when test="(string($wrap) = 'false') and (number($wrap) = 0)">
							<xsl:value-of select="$key"/>
						</xsl:when>
						<xsl:when test="(string($wrap) != 'true') and (number($wrap) != 1)">
							<xsl:value-of select="$wrap"/>
						</xsl:when>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="value1"/>
		<xsl:param name="key1"/>
		<xsl:param name="type1">string</xsl:param>
		<xsl:param name="value2"/>
		<xsl:param name="key2"/>
		<xsl:param name="type2">string</xsl:param>
		<xsl:param name="value3"/>
		<xsl:param name="key3"/>
		<xsl:param name="type3">string</xsl:param>

		<xsl:choose>
			<xsl:when test="$wrap">
				<xsl:call-template name="cxsltl:json.generate.contener">
					<xsl:with-param name="value">
						<xsl:call-template name="cxsltl:json.generate.contener">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="key" select="$key"/>
							<xsl:with-param name="type" select="$type"/>
							<xsl:with-param name="depth" select="$depth + 1"/>
							<xsl:with-param name="indent" select="$indent"/>
							<xsl:with-param name="eol" select="$eol"/>
							<xsl:with-param name="last" select="true()"/>
							<xsl:with-param name="value1" select="$value1"/>
							<xsl:with-param name="key1" select="$key1"/>
							<xsl:with-param name="type1" select="$type1"/>
							<xsl:with-param name="value2" select="$value2"/>
							<xsl:with-param name="key2" select="$key2"/>
							<xsl:with-param name="type2" select="$type2"/>
							<xsl:with-param name="value3" select="$value3"/>
							<xsl:with-param name="key3" select="$key3"/>
							<xsl:with-param name="type3" select="$type3"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="type">
						<xsl:choose>
							<xsl:when test="string($key)">object</xsl:when>
							<xsl:otherwise>array</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="depth" select="$depth"/>
					<xsl:with-param name="indent" select="$indent"/>
					<xsl:with-param name="eol" select="$eol"/>
					<xsl:with-param name="last" select="$last"/>
					<xsl:with-param name="prefix" select="$prefix"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$type = 'array'">
						<xsl:call-template name="cxsltl:json.generate.array">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="depth" select="$depth"/>
							<xsl:with-param name="indent" select="$indent"/>
							<xsl:with-param name="eol" select="$eol"/>
							<xsl:with-param name="last" select="$last and not(string($value1))"/>
							<xsl:with-param name="prefix" select="$prefix"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$type = 'auto'">
						<xsl:call-template name="cxsltl:json.generate.auto">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="eol" select="$eol"/>
							<xsl:with-param name="last" select="$last and not(string($value1))"/>
							<xsl:with-param name="prefix" select="$prefix"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$type = 'literal'">
						<xsl:call-template name="cxsltl:json.generate.literal">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="eol" select="$eol"/>
							<xsl:with-param name="last" select="$last and not(string($value1))"/>
							<xsl:with-param name="prefix" select="$prefix"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$type = 'object'">
						<xsl:call-template name="cxsltl:json.generate.object">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="depth" select="$depth"/>
							<xsl:with-param name="indent" select="$indent"/>
							<xsl:with-param name="eol" select="$eol"/>
							<xsl:with-param name="last" select="$last and not(string($value1))"/>
							<xsl:with-param name="prefix" select="$prefix"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$type = 'string'">
						<xsl:call-template name="cxsltl:json.generate.string">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="eol" select="$eol"/>
							<xsl:with-param name="last" select="$last and not(string($value1))"/>
							<xsl:with-param name="prefix" select="$prefix"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$type = 'null' or $type = 'true' or $type = 'false'">
						<xsl:call-template name="cxsltl:json.generate.literal">
							<xsl:with-param name="value" select="$type"/>
							<xsl:with-param name="eol" select="$eol"/>
							<xsl:with-param name="last" select="$last and not(string($value1))"/>
							<xsl:with-param name="prefix" select="$prefix"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message terminate="yes">$type is only a "array" or "auto" or "literal" or "false" or "null" or "object" or "string" or "true".</xsl:message>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:if test="string($value1)">
					<xsl:call-template name="cxsltl:json.generate.contener">
						<xsl:with-param name="value" select="$value1"/>
						<xsl:with-param name="prefix">
							<xsl:choose>
								<xsl:when test="contains($prefix, ':')">
									<xsl:call-template name="cxsltl:json.generate.key">
										<xsl:with-param name="key" select="$key1"/>
										<xsl:with-param name="indent" select="$indent"/>
										<xsl:with-param name="depth" select="$depth"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="cxsltl:json.generate.indentRepeat">
										<xsl:with-param name="indent" select="$indent"/>
										<xsl:with-param name="depth" select="$depth"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="type" select="$type1"/>
						<xsl:with-param name="depth" select="$depth"/>
						<xsl:with-param name="indent" select="$indent"/>
						<xsl:with-param name="eol" select="$eol"/>
						<xsl:with-param name="last" select="$last"/>
						<xsl:with-param name="value1" select="$value2"/>
						<xsl:with-param name="key1" select="$key2"/>
						<xsl:with-param name="type1" select="$type2"/>
						<xsl:with-param name="value2" select="$value3"/>
						<xsl:with-param name="key2" select="$key3"/>
						<xsl:with-param name="type2" select="$type3"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>falseを作成する</xsltdoc:short>
		<xsltdoc:version>2017-06-02</xsltdoc:version>
		<xsltdoc:since>2017-06-02</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行文字"/>
		<xsltdoc:paramBoolean xsltdoc:name="last" xsltdoc:short="false()ならば末尾にカンマを生成する"/>
		<xsltdoc:paramString xsltdoc:name="prefix" xsltdoc:short="接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="JSONのFalseを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:json.generate.false">
		<xsl:param name="key"/>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="indent" select="'&#x9;'"/>
		<xsl:param name="eol" select="'&#xA;'"/>
		<xsl:param name="last" select="false()"/>
		<xsl:param name="prefix">
			<xsl:call-template name="cxsltl:json.generate.prefix">
				<xsl:with-param name="key" select="$key"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
		</xsl:param>

		<xsl:value-of select="concat($prefix, 'false')"/>

		<xsl:if test="not($last)">
			<xsl:value-of select="concat(',', $eol)"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>インデントを繰り返す</xsltdoc:short>
		<xsltdoc:version>2015-06-18</xsltdoc:version>
		<xsltdoc:since>2015-06-18</xsltdoc:since>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:returnString xsltdoc:short="繰り返されたインデントの文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:json.generate.indentRepeat">
		<xsl:param name="depth" select="0"/>
		<xsl:param name="indent" select="'&#x9;'"/>

		<xsl:call-template name="cxsltl:string.repeat">
			<xsl:with-param name="string" select="$indent"/>
			<xsl:with-param name="multiplier" select="$depth"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>JSONのkeyを生成する</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is "keyName":</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:json.generate.key">
					<xsl:with-param name="key">keyName</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-06-18</xsltdoc:version>
		<xsltdoc:since>2015-05-28</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="keyとなる文字列"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:returnString xsltdoc:short="JSON key"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:json.generate.key">
		<xsl:param name="key" select="."/>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="indent" select="'&#x9;'"/>

		<xsl:call-template name="cxsltl:json.generate.string">
			<xsl:with-param name="value" select="$key"/>
			<xsl:with-param name="depth" select="$depth"/>
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="last" select="true()"/>
		</xsl:call-template>

		<xsl:text>:</xsl:text>

		<xsl:if test="string($indent)">
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>リテラルを作成する</xsltdoc:short>
		<xsltdoc:version>2017-06-02</xsltdoc:version>
		<xsltdoc:since>2017-06-02</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行文字"/>
		<xsltdoc:paramBoolean xsltdoc:name="last" xsltdoc:short="false()ならば末尾にカンマを生成する"/>
		<xsltdoc:paramString xsltdoc:name="prefix" xsltdoc:short="接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="JSONのリテラルを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:json.generate.literal">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="indent" select="'&#x9;'"/>
		<xsl:param name="eol" select="'&#xA;'"/>
		<xsl:param name="last" select="false()"/>
		<xsl:param name="prefix">
			<xsl:call-template name="cxsltl:json.generate.prefix">
				<xsl:with-param name="key" select="$key"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
		</xsl:param>

		<xsl:value-of select="$prefix"/>

		<xsl:call-template name="cxsltl:json.generate.trim">
			<xsl:with-param name="string" select="$value"/>
		</xsl:call-template>

		<xsl:if test="not($last)">
			<xsl:value-of select="concat(',', $eol)"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>nullを作成する</xsltdoc:short>
		<xsltdoc:version>2017-06-02</xsltdoc:version>
		<xsltdoc:since>2017-06-02</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行文字"/>
		<xsltdoc:paramBoolean xsltdoc:name="last" xsltdoc:short="false()ならば末尾にカンマを生成する"/>
		<xsltdoc:paramString xsltdoc:name="prefix" xsltdoc:short="接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="JSONのnullを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:json.generate.null">
		<xsl:param name="key"/>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="indent" select="'&#x9;'"/>
		<xsl:param name="eol" select="'&#xA;'"/>
		<xsl:param name="last" select="false()"/>
		<xsl:param name="prefix">
			<xsl:call-template name="cxsltl:json.generate.prefix">
				<xsl:with-param name="key" select="$key"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
		</xsl:param>

		<xsl:value-of select="concat($prefix, 'null')"/>

		<xsl:if test="not($last)">
			<xsl:value-of select="concat(',', $eol)"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>オブジェクトを作成する</xsltdoc:short>
		<xsltdoc:version>2017-06-02</xsltdoc:version>
		<xsltdoc:since>2017-06-02</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行文字"/>
		<xsltdoc:paramBoolean xsltdoc:name="last" xsltdoc:short="false()ならば末尾にカンマを生成する"/>
		<xsltdoc:paramString xsltdoc:name="prefix" xsltdoc:short="接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="JSONのオブジェクトを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:json.generate.object">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="indent" select="'&#x9;'"/>
		<xsl:param name="eol" select="'&#xA;'"/>
		<xsl:param name="last" select="false()"/>
		<xsl:param name="prefix">
			<xsl:call-template name="cxsltl:json.generate.prefix">
				<xsl:with-param name="key" select="$key"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
		</xsl:param>

		<xsl:variable name="trimed">
			<xsl:call-template name="cxsltl:json.generate.trim">
				<xsl:with-param name="string" select="$value"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="indents">
			<xsl:if test="string($trimed)">
				<xsl:value-of select="$eol"/>

				<xsl:call-template name="cxsltl:json.generate.indentRepeat">
					<xsl:with-param name="indent" select="$indent"/>
					<xsl:with-param name="depth" select="$depth"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>

		<xsl:value-of select="concat($prefix, '{', $indents)"/>

		<xsl:if test="string($trimed)">
			<xsl:value-of select="$indent"/>
		</xsl:if>

		<xsl:value-of select="concat($trimed, $indents, '}')"/>

		<xsl:if test="not($last)">
			<xsl:value-of select="concat(',', $eol)"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>インデントとキーを作成する</xsltdoc:short>
		<xsltdoc:version>2017-06-02</xsltdoc:version>
		<xsltdoc:since>2017-06-02</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:returnString xsltdoc:short="JSONのインデントとキーを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:json.generate.prefix">
		<xsl:param name="key"/>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="indent" select="'&#x9;'"/>

		<xsl:call-template name="cxsltl:json.generate.indentRepeat">
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="depth" select="$depth"/>
		</xsl:call-template>

		<xsl:if test="string($key)">
			<xsl:call-template name="cxsltl:json.generate.key">
				<xsl:with-param name="key" select="$key"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="depth" select="0"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列を作成する</xsltdoc:short>
		<xsltdoc:version>2017-06-02</xsltdoc:version>
		<xsltdoc:since>2017-06-02</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行文字"/>
		<xsltdoc:paramBoolean xsltdoc:name="last" xsltdoc:short="false()ならば末尾にカンマを生成する"/>
		<xsltdoc:paramString xsltdoc:name="prefix" xsltdoc:short="接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="JSONの文字列を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:json.generate.string">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="indent" select="'&#x9;'"/>
		<xsl:param name="eol" select="'&#xA;'"/>
		<xsl:param name="last" select="false()"/>
		<xsl:param name="prefix">
			<xsl:call-template name="cxsltl:json.generate.prefix">
				<xsl:with-param name="key" select="$key"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
		</xsl:param>

		<xsl:value-of select="$prefix"/>

		<xsl:text>"</xsl:text>

		<xsl:call-template name="cxsltl:string.backslashEscape">
			<xsl:with-param name="string" select="$value"/>
			<xsl:with-param name="charlist">/</xsl:with-param>
		</xsl:call-template>

		<xsl:text>"</xsl:text>

		<xsl:if test="not($last)">
			<xsl:value-of select="concat(',', $eol)"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列の文頭と文末からカンマを取り除く</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is "a, b, c"</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:json.generate.trim">
					<xsl:with-param name="string">a, b, c, </xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-01-21</xsltdoc:version>
		<xsltdoc:since>2015-01-21</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="入力文字列"/>
		<xsltdoc:paramString xsltdoc:name="charlist" xsltdoc:short="取り除く文字"/>
		<xsltdoc:returnString xsltdoc:short="文頭と文末から空白とカンマが取り除かれた文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:json.generate.trim">
		<xsl:param name="string" select="."/>
		<xsl:param name="charlist" select="'&#x9;&#xA;&#xD; ,'"/>

		<xsl:call-template name="cxsltl:string.bothTrim">
			<xsl:with-param name="string" select="$string"/>
			<xsl:with-param name="charlist" select="$charlist"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>trueを作成する</xsltdoc:short>
		<xsltdoc:version>2017-06-02</xsltdoc:version>
		<xsltdoc:since>2017-06-02</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行文字"/>
		<xsltdoc:paramBoolean xsltdoc:name="last" xsltdoc:short="false()ならば末尾にカンマを生成する"/>
		<xsltdoc:paramString xsltdoc:name="prefix" xsltdoc:short="接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="JSONのTrueを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:json.generate.true">
		<xsl:param name="key"/>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="indent" select="'&#x9;'"/>
		<xsl:param name="eol" select="'&#xA;'"/>
		<xsl:param name="last" select="false()"/>
		<xsl:param name="prefix">
			<xsl:call-template name="cxsltl:json.generate.prefix">
				<xsl:with-param name="key" select="$key"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
		</xsl:param>

		<xsl:value-of select="concat($prefix, 'true')"/>

		<xsl:if test="not($last)">
			<xsl:value-of select="concat(',', $eol)"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>JSONの型変換を行う</xsltdoc:short>
		<xsltdoc:version>2015-05-29</xsltdoc:version>
		<xsltdoc:since>2015-05-29</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="変換する値"/>
		<xsltdoc:paramString xsltdoc:name="type" xsltdoc:short="変換する型"/>
		<xsltdoc:paramString xsltdoc:name="objectKey" xsltdoc:short="オブジェクトに変換をする時のキー"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行文字"/>
		<xsltdoc:paramBoolean xsltdoc:name="last" xsltdoc:short="false()ならば末尾にカンマを生成する"/>
		<xsltdoc:returnString xsltdoc:short="$typeごとに変換した値"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:json.generate.typeConversion">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>
		<xsl:param name="type">string</xsl:param>
		<xsl:param name="objectKey">key</xsl:param>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="indent" select="'&#x9;'"/>
		<xsl:param name="eol" select="'&#xA;'"/>
		<xsl:param name="last" select="true()"/>
		<xsl:param name="prefix">
			<xsl:call-template name="cxsltl:json.generate.prefix">
				<xsl:with-param name="key" select="$key"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
		</xsl:param>

		<xsl:variable name="trimmed">
			<xsl:call-template name="cxsltl:json.generate.trim">
				<xsl:with-param name="string" select="$value"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="trimmedLrngth" select="string-length($trimmed)"/>

		<xsl:variable name="start" select="substring($trimmed, 1, 1)"/>
		<xsl:variable name="end" select="substring($trimmed, $trimmedLrngth)"/>
		<xsl:variable name="content" select="normalize-space(substring($trimmed, 2, $trimmedLrngth - 2))"/>

		<xsl:variable name="from">
			<xsl:choose>
				<xsl:when test="$start = '[' and $end = ']'">array</xsl:when>
				<xsl:when test="$start = '{' and $end = '}'">object</xsl:when>
				<xsl:when test="$start = '&quot;' and $end = '&quot;'">string</xsl:when>
				<xsl:when test="string(number($trimmed)) != 'NaN'">
					<xsl:choose>
						<xsl:when test="$trimmed mod 1 = 0">integer</xsl:when>
						<xsl:otherwise>number</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$trimmed = 'true' or $trimmed = 'false'">boolean</xsl:when>
				<xsl:when test="$trimmed = 'null'">null</xsl:when>
				<xsl:otherwise>
					<xsl:message terminate="yes">$value is not JSON.</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$type = $from or ($type = 'number' and $from = 'integer')">
				<xsl:call-template name="cxsltl:json.generate.literal">
					<xsl:with-param name="value" select="$trimmed"/>
					<xsl:with-param name="type">literal</xsl:with-param>
					<xsl:with-param name="eol" select="$eol"/>
					<xsl:with-param name="last" select="$last"/>
					<xsl:with-param name="prefix" select="$prefix"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$type = 'array'">
				<xsl:call-template name="cxsltl:json.generate.array">
					<xsl:with-param name="value" select="$trimmed"/>
					<xsl:with-param name="depth" select="$depth"/>
					<xsl:with-param name="indent" select="$indent"/>
					<xsl:with-param name="eol" select="$eol"/>
					<xsl:with-param name="last" select="$last"/>
					<xsl:with-param name="prefix" select="$prefix"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$type = 'boolean'">
				<xsl:call-template name="cxsltl:json.generate.literal">
					<xsl:with-param name="value">
						<xsl:choose>
							<xsl:when test="
								string($content) and ($from = 'object' or $from = 'array' or $from = 'string') or
								not(string(number($trimmed)) = 'NaN' or number($trimmed) = 0) or
								$trimmed = 'true'
							">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="eol" select="$eol"/>
					<xsl:with-param name="last" select="$last"/>
					<xsl:with-param name="prefix" select="$prefix"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$type = 'integer' or $type = 'number'">
				<xsl:call-template name="cxsltl:json.generate.literal">
					<xsl:with-param name="value">
						<xsl:choose>
							<xsl:when test="$type = 'integer' and $from = 'number'">
								<xsl:value-of select="floor($trimmed)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="boolean">
									<xsl:call-template name="cxsltl:json.generate.typeConversion">
										<xsl:with-param name="value" select="$trimmed"/>
										<xsl:with-param name="type">boolean</xsl:with-param>
									</xsl:call-template>
								</xsl:variable>

								<xsl:choose>
									<xsl:when test="$boolean = 'true'">1</xsl:when>
									<xsl:otherwise>0</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="eol" select="$eol"/>
					<xsl:with-param name="last" select="$last"/>
					<xsl:with-param name="prefix" select="$prefix"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$type = 'object'">
				<xsl:call-template name="cxsltl:json.generate.contener">
					<xsl:with-param name="value" select="$trimmed"/>
					<xsl:with-param name="key" select="$objectKey"/>
					<xsl:with-param name="type">literal</xsl:with-param>
					<xsl:with-param name="depth" select="$depth"/>
					<xsl:with-param name="indent" select="$indent"/>
					<xsl:with-param name="eol" select="$eol"/>
					<xsl:with-param name="last" select="$last"/>
					<xsl:with-param name="wrap" select="true()"/>
					<xsl:with-param name="prefix" select="$prefix"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$type = 'string'">
				<xsl:call-template name="cxsltl:json.generate.string">
					<xsl:with-param name="value" select="$trimmed"/>
					<xsl:with-param name="eol" select="$eol"/>
					<xsl:with-param name="last" select="$last"/>
					<xsl:with-param name="prefix" select="$prefix"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">$type is only a "array" or "boolean" or "integer" or "number" or "object" or "string".</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>