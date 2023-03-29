<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../date/iso8601/datetime.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>Property listを扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-06-09</xsltdoc:version>
		<xsltdoc:since>2017-05-17</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man5/plist.5.html"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>array要素を作成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:returnNodeSet xsltdoc:short="array要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:plist.generate.array">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>

		<xsl:if test="string($key)">
			<xsl:call-template name="cxsltl:plist.generate.key">
				<xsl:with-param name="value" select="$key"/>
			</xsl:call-template>
		</xsl:if>

		<array>
			<xsl:copy-of select="$value"/>
		</array>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>$valueの内容に応じた型要素を作成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:returnNodeSet xsltdoc:short="型要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:plist.generate.auto">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>

		<xsl:call-template name="cxsltl:plist.generate.contener">
			<xsl:with-param name="value" select="."/>
			<xsl:with-param name="key"/>
			<xsl:with-param name="type">
				<xsl:choose>
					<xsl:when test="$value = 'true' or $value = 'false'">
						<xsl:value-of select="$value"/>
					</xsl:when>
					<xsl:when test="string(number($value)) != 'NaN'">
						<xsl:choose>
							<xsl:when test="$value mod 1 = 0">integer</xsl:when>
							<xsl:otherwise>real</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="checkDate">
							<xsl:call-template name="cxsltl:date.iso8601.datetime.checkDateTimePoint">
								<xsl:with-param name="string" select="$value"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:choose>
							<xsl:when test="number($checkDate)">date</xsl:when>
							<xsl:otherwise>string</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>$typeに応じた型要素を作成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:paramString xsltdoc:name="type" xsltdoc:short="$valueの型"/>
		<xsltdoc:paramBoolean xsltdoc:name="wrap" xsltdoc:short="true()ならば配列かオブジェクトで包む"/>
		<xsltdoc:paramString xsltdoc:name="value1" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key1" xsltdoc:short="$value1のキーとなる文字列"/>
		<xsltdoc:paramString xsltdoc:name="type1" xsltdoc:short="$value1の型"/>
		<xsltdoc:paramString xsltdoc:name="value2" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key2" xsltdoc:short="$value2のキーとなる文字列"/>
		<xsltdoc:paramString xsltdoc:name="type2" xsltdoc:short="$value2の型"/>
		<xsltdoc:paramString xsltdoc:name="value3" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key3" xsltdoc:short="$value3のキーとなる文字列"/>
		<xsltdoc:paramString xsltdoc:name="type3" xsltdoc:short="$value3の型"/>
		<xsltdoc:returnNodeSet xsltdoc:short="型要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:plist.generate.contener">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>
		<xsl:param name="type">string</xsl:param>
		<xsl:param name="wrap" select="false()"/>
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
				<xsl:call-template name="cxsltl:plist.generate.contener">
					<xsl:with-param name="value">
						<xsl:call-template name="cxsltl:plist.generate.contener">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="key" select="$key"/>
							<xsl:with-param name="type" select="$type"/>
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
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$type = 'array'">
						<xsl:call-template name="cxsltl:plist.generate.array">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="key" select="$key"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$type = 'auto'">
						<xsl:call-template name="cxsltl:plist.generate.auto">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="key" select="$key"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$type = 'false'">
						<xsl:call-template name="cxsltl:plist.generate.false">
							<xsl:with-param name="key" select="$key"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$type = 'data'">
						<xsl:call-template name="cxsltl:plist.generate.data">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="key" select="$key"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$type = 'date'">
						<xsl:call-template name="cxsltl:plist.generate.date">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="key" select="$key"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$type = 'integer'">
						<xsl:call-template name="cxsltl:plist.generate.integer">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="key" select="$key"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$type = 'object'">
						<xsl:call-template name="cxsltl:plist.generate.dict">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="key" select="$key"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$type = 'real'">
						<xsl:call-template name="cxsltl:plist.generate.real">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="key" select="$key"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$type = 'string'">
						<xsl:call-template name="cxsltl:plist.generate.string">
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="key" select="$key"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$type = 'true'">
						<xsl:call-template name="cxsltl:plist.generate.true">
							<xsl:with-param name="key" select="$key"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message terminate="yes">cxsltl:plist.generate.contener: $type is only a "array" or "auto" or "boolean" or "data" or "date" or "integer" or "object" or "real" or "string".</xsl:message>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:if test="string($value1)">
					<xsl:call-template name="cxsltl:plist.generate.contener">
						<xsl:with-param name="value" select="$value1"/>
						<xsl:with-param name="key" select="$key1"/>
						<xsl:with-param name="type" select="$type1"/>
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
		<xsltdoc:short>data要素を作成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:returnNodeSet xsltdoc:short="data要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:plist.generate.data">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>

		<xsl:if test="string($key)">
			<xsl:call-template name="cxsltl:plist.generate.key">
				<xsl:with-param name="value" select="$key"/>
			</xsl:call-template>
		</xsl:if>

		<data>
			<xsl:copy-of select="$value"/>
		</data>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>date要素を作成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:returnNodeSet xsltdoc:short="date要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:plist.generate.date">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>

		<xsl:if test="string($key)">
			<xsl:call-template name="cxsltl:plist.generate.key">
				<xsl:with-param name="value" select="$key"/>
			</xsl:call-template>
		</xsl:if>

		<date>
			<xsl:copy-of select="$value"/>
		</date>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>dict要素を作成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:returnNodeSet xsltdoc:short="dict要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:plist.generate.dict">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>

		<xsl:if test="string($key)">
			<xsl:call-template name="cxsltl:plist.generate.key">
				<xsl:with-param name="value" select="$key"/>
			</xsl:call-template>
		</xsl:if>

		<dict>
			<xsl:copy-of select="$value"/>
		</dict>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>false要素を作成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:returnNodeSet xsltdoc:short="false要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:plist.generate.false">
		<xsl:param name="key"/>

		<xsl:if test="string($key)">
			<xsl:call-template name="cxsltl:plist.generate.key">
				<xsl:with-param name="value" select="$key"/>
			</xsl:call-template>
		</xsl:if>

		<false/>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>integer要素を作成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:returnNodeSet xsltdoc:short="integer要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:plist.generate.integer">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>

		<xsl:if test="string($key)">
			<xsl:call-template name="cxsltl:plist.generate.key">
				<xsl:with-param name="value" select="$key"/>
			</xsl:call-template>
		</xsl:if>

		<integer>
			<xsl:copy-of select="$value"/>
		</integer>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>key要素を作成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramBoolean xsltdoc:name="escape" xsltdoc:short="true()ならば要素の内容をエスケープする"/>
		<xsltdoc:returnNodeSet xsltdoc:short="key要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:plist.generate.key">
		<xsl:param name="value" select="."/>

		<key>
			<xsl:copy-of select="$value"/>
		</key>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>plist要素を作成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="version" xsltdoc:short="Property listのバージョン"/>
		<xsltdoc:returnNodeSet xsltdoc:short="plist要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:plist.generate.plist">
		<xsl:param name="value" select="."/>
		<xsl:param name="version">1.0</xsl:param>

		<plist version="{$version}">
			<xsl:copy-of select="$value"/>
		</plist>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>real要素を作成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:returnNodeSet xsltdoc:short="real要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:plist.generate.real">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>

		<xsl:if test="string($key)">
			<xsl:call-template name="cxsltl:plist.generate.key">
				<xsl:with-param name="value" select="$key"/>
			</xsl:call-template>
		</xsl:if>

		<real>
			<xsl:copy-of select="$value"/>
		</real>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>string要素を作成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:paramBoolean xsltdoc:name="escape" xsltdoc:short="true()ならば要素の内容をエスケープする"/>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:returnNodeSet xsltdoc:short="string要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:plist.generate.string">
		<xsl:param name="value" select="."/>
		<xsl:param name="key"/>

		<xsl:if test="string($key)">
			<xsl:call-template name="cxsltl:plist.generate.key">
				<xsl:with-param name="value" select="$key"/>
			</xsl:call-template>
		</xsl:if>

		<string>
			<xsl:copy-of select="$value"/>
		</string>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>true要素を作成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="key" xsltdoc:short="キーとなる文字列"/>
		<xsltdoc:returnNodeSet xsltdoc:short="true要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:plist.generate.true">
		<xsl:param name="key"/>

		<xsl:if test="string($key)">
			<xsl:call-template name="cxsltl:plist.generate.key">
				<xsl:with-param name="value" select="$key"/>
			</xsl:call-template>
		</xsl:if>

		<true/>
	</xsl:template>
</xsl:stylesheet>