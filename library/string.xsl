<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="common.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>文字列を扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2015-11-18</xsltdoc:version>
		<xsltdoc:since>2014-05-29</xsltdoc:since>
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

	<xsl:variable name="cxsltl:string.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>特殊文字をバックスラッシュでエスケープする置換用の要素</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:string.backslashEscape" select="$cxsltl:string.self/cxsltl:string.search[@xml:id = 'cxsltl.string.backslashEscape']/*"/>

	<!-- ==============================
		# cxsltl:string.search Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.string.backslashEscape">
		<xsltdoc:short>特殊文字をバックスラッシュでエスケープする置換用の要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:string.search xml:id="cxsltl.string.backslashEscape">
		<cxsltl:string.replace src="\" dst="\\"/>
		<cxsltl:string.replace src="&quot;" dst="\&quot;"/>
		<cxsltl:string.replace src="&#xA;" dst="\n"/>
		<cxsltl:string.replace src="&#xD;" dst="\r"/>
		<cxsltl:string.replace src="&#x9;" dst="\t"/>
	</cxsltl:string.search>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>特殊文字をバックスラッシュでエスケープする</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is [\"a\", \"b\", \"\c\", \"\d\"]</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.backslashEscape">
					<xsl:with-param name="string">["a", "b", "c", "d"]</xsl:with-param>
					<xsl:with-param name="charlist">cd</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-01-11</xsltdoc:version>
		<xsltdoc:since>2014-12-29</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="変換される文字列"/>
		<xsltdoc:paramString xsltdoc:name="charlist" xsltdoc:short="追加でバックスラッシュでエスケープを行う特殊文字"/>
		<xsltdoc:returnString xsltdoc:short="バックスラッシュでエスケープされた文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.backslashEscape">
		<xsl:param name="string" select="."/>
		<xsl:param name="charlist"/>

		<xsl:call-template name="cxsltl:string.escape">
			<xsl:with-param name="string">
				<xsl:call-template name="cxsltl:string.multipleReplace">
					<xsl:with-param name="node" select="$cxsltl:string.backslashEscape"/>
					<xsl:with-param name="string" select="$string"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="charlist" select="$charlist"/>
			<xsl:with-param name="escape">\</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列の文頭と文末から空白を取り除く</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is "a b c"</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.bothTrim">
					<xsl:with-param name="string"> a b c </xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-01-15</xsltdoc:version>
		<xsltdoc:since>2015-01-15</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="入力文字列"/>
		<xsltdoc:paramString xsltdoc:name="charlist" xsltdoc:short="取り除く文字"/>
		<xsltdoc:paramString xsltdoc:name="except" xsltdoc:short="除外する文字"/>
		<xsltdoc:returnString xsltdoc:short="文頭と文末から空白が取り除かれた文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.bothTrim">
		<xsl:param name="string" select="."/>
		<xsl:param name="charlist" select="'&#x9;&#xA;&#xD; '"/>
		<xsl:param name="except"/>

		<xsl:call-template name="cxsltl:string.rightTrim">
			<xsl:with-param name="string">
				<xsl:call-template name="cxsltl:string.leftTrim">
					<xsl:with-param name="string" select="$string"/>
					<xsl:with-param name="charlist" select="$charlist"/>
					<xsl:with-param name="except" select="$except"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="charlist" select="$charlist"/>
			<xsl:with-param name="except" select="$except"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="cxsltl:string.characterMatch">
		<xsl:param name="string" select="."/>
		<xsl:param name="charlist">0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</xsl:param>

		<xsl:variable name="character" select="substring($string, 1, 1)"/>

		<xsl:if test="$character and contains($charlist, $character)">
			<xsl:value-of select="$character"/>

			<xsl:call-template name="cxsltl:string.characterMatch">
				<xsl:with-param name="string" select="substring($string, 2)"/>
				<xsl:with-param name="charlist" select="$charlist"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="cxsltl:string.characterNotMatch">
		<xsl:param name="string" select="."/>
		<xsl:param name="charlist"/>

		<xsl:variable name="character" select="substring($string, 1, 1)"/>

		<xsl:if test="$character and not(contains($charlist, $character))">
			<xsl:value-of select="$character"/>

			<xsl:call-template name="cxsltl:string.characterNotMatch">
				<xsl:with-param name="string" select="substring($string, 2)"/>
				<xsl:with-param name="charlist" select="$charlist"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>特殊文字を任意の文字でエスケープする</xsltdoc:short>
		<xsltdoc:version>2015-01-11</xsltdoc:version>
		<xsltdoc:since>2015-01-10</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="変換される文字列"/>
		<xsltdoc:paramString xsltdoc:name="charlist" xsltdoc:short="エスケープする特殊文字"/>
		<xsltdoc:paramString xsltdoc:name="escape" xsltdoc:short="エスケープの開始文字"/>
		<xsltdoc:returnString xsltdoc:short="エスケープされた文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.escape">
		<xsl:param name="string" select="."/>
		<xsl:param name="charlist"/>
		<xsl:param name="escape">\</xsl:param>

		<xsl:choose>
			<xsl:when test="string($charlist)">
				<xsl:call-template name="cxsltl:string.escape">
					<xsl:with-param name="string">
						<xsl:call-template name="cxsltl:string.replace">
							<xsl:with-param name="string" select="$string"/>
							<xsl:with-param name="src" select="substring($charlist, 1, 1)"/>
							<xsl:with-param name="dst" select="concat($escape, substring($charlist, 1, 1))"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="charlist" select="substring($charlist, 2)"/>
					<xsl:with-param name="escape" select="$escape"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列がASCIIのみで構成されているか検査する</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is 1</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.isAsciiCharacter">
					<xsl:with-param name="string">Archimedes</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is 0</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.isAsciiCharacter">
					<xsl:with-param name="string">Ἀρχιμήδης</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-01-11</xsltdoc:version>
		<xsltdoc:since>2014-12-24</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="検査する文字列"/>
		<xsltdoc:paramString xsltdoc:name="charlist" xsltdoc:short="ASCII文字の一覧"/>
		<xsltdoc:paramString xsltdoc:name="escape" xsltdoc:short="エスケープの開始文字"/>
		<xsltdoc:returnString xsltdoc:short="ASCIIのみならば1を、それ以外ならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.isAsciiCharacter">
		<xsl:param name="string" select="."/>
		<xsl:param name="charlist">&#x9;&#xA;&#xD; !"#$%&amp;'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~</xsl:param>

		<xsl:choose>
			<xsl:when test="not(translate($string, $charlist, ''))">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列中の最後の副文字列以後の文字を返す</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is banana</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.lastSubstringAfter">
					<xsl:with-param name="string">apple, orange, strawberry, banana</xsl:with-param>
					<xsl:with-param name="substring" select="', '"/>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-06-01</xsltdoc:version>
		<xsltdoc:since>2015-01-05</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="文字列"/>
		<xsltdoc:paramString xsltdoc:name="substring" xsltdoc:short="副文字列"/>
		<xsltdoc:paramBoolean xsltdoc:name="return" xsltdoc:short="値がtrue()で$string内に$substringが無い場合は$stringをそのまま返す"/>
		<xsltdoc:returnString xsltdoc:short="文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.lastSubstringAfter">
		<xsl:param name="string" select="."/>
		<xsl:param name="substring" select="."/>
		<xsl:param name="return" select="false()"/>

		<xsl:call-template name="cxsltl:string.split">
			<xsl:with-param name="callback" select="$cxsltl:string.self/xsl:template[@name = 'cxsltl:string.callback.lastSubstringAfter']"/>
			<xsl:with-param name="string" select="$string"/>
			<xsl:with-param name="delimiter" select="$substring"/>
		</xsl:call-template>

		<xsl:if test="$return and not(string($substring) and contains($string, $substring))">
			<xsl:value-of select="$string"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:version>2015-01-05</xsltdoc:version>
		<xsltdoc:since>2015-01-05</xsltdoc:since>
		<xsltdoc:private/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:string.callback.lastSubstringAfter']" mode="cxsltl:callback" name="cxsltl:string.callback.lastSubstringAfter">
		<xsl:param name="string"/>
		<xsl:param name="position"/>
		<xsl:param name="count"/>

		<xsl:if test="($position = $count) and ($count != 1)">
			<xsl:value-of select="$string"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列中の最後の副文字列以前の文字を返す</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is apple, orange, strawberry</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.lastSubstringBefore">
					<xsl:with-param name="string">apple, orange, strawberry, banana</xsl:with-param>
					<xsl:with-param name="substring" select="', '"/>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-06-01</xsltdoc:version>
		<xsltdoc:since>2015-01-05</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="文字列"/>
		<xsltdoc:paramString xsltdoc:name="substring" xsltdoc:short="副文字列"/>
		<xsltdoc:paramBoolean xsltdoc:name="return" xsltdoc:short="値がtrue()で$string内に$substringが無い場合は$stringをそのまま返す"/>
		<xsltdoc:returnString xsltdoc:short="文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.lastSubstringBefore">
		<xsl:param name="string" select="."/>
		<xsl:param name="substring" select="."/>
		<xsl:param name="return" select="false()"/>

		<xsl:call-template name="cxsltl:string.split">
			<xsl:with-param name="callback" select="$cxsltl:string.self/xsl:template[@name = 'cxsltl:string.callback.lastSubstringBefore']"/>
			<xsl:with-param name="string" select="$string"/>
			<xsl:with-param name="delimiter" select="$substring"/>
		</xsl:call-template>

		<xsl:if test="$return and not(string($substring) and contains($string, $substring))">
			<xsl:value-of select="$string"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:version>2015-01-05</xsltdoc:version>
		<xsltdoc:since>2015-01-05</xsltdoc:since>
		<xsltdoc:private/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:string.callback.lastSubstringBefore']" mode="cxsltl:callback" name="cxsltl:string.callback.lastSubstringBefore">
		<xsl:param name="string"/>
		<xsl:param name="delimiter"/>
		<xsl:param name="position"/>
		<xsl:param name="count"/>

		<xsl:if test="$position != $count">
			<xsl:value-of select="$string"/>
		</xsl:if>

		<xsl:if test="$position &lt; ($count - 1)">
			<xsl:value-of select="$delimiter"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列の文頭から空白を取り除く</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is "a b c "</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.leftTrim">
					<xsl:with-param name="string"> a b c </xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-01-15</xsltdoc:version>
		<xsltdoc:since>2015-01-15</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="入力文字列"/>
		<xsltdoc:paramString xsltdoc:name="charlist" xsltdoc:short="取り除く文字"/>
		<xsltdoc:paramString xsltdoc:name="except" xsltdoc:short="除外する文字"/>
		<xsltdoc:returnString xsltdoc:short="文頭から空白が取り除かれた文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.leftTrim">
		<xsl:param name="string" select="."/>
		<xsl:param name="charlist" select="'&#x9;&#xA;&#xD; '"/>
		<xsl:param name="except"/>

		<xsl:variable name="left" select="substring($string, 1, 1)"/>

		<xsl:choose>
			<xsl:when test="not(string($string)) or (translate($left, $charlist, '') and translate($left, $except, ''))">
				<xsl:value-of select="$string"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="not(translate($left, $except, ''))">
					<xsl:value-of select="$left"/>
				</xsl:if>

				<xsl:call-template name="cxsltl:string.leftTrim">
					<xsl:with-param name="string" select="substring($string, 2)"/>
					<xsl:with-param name="charlist" select="$charlist"/>
					<xsl:with-param name="except" select="$except"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列を複数回再帰的に置換する</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is apple orange raspberry banana</xsltdoc:short>
			<rdf:value><![CDATA[
				<string.search xmlns="http://purl.org/meta/ns/xslt/#">
					<string.replace src="strawberry" dst="blueberry"/>
					<string.replace src="blueberry" dst="blackberry"/>
					<string.replace src="blackberry" dst="raspberry"/>
				</string.search>

				<xsl:template match="/">
					<xsl:call-template name="cxsltl:string.multipleReplace">
						<xsl:with-param name="string">apple orange strawberry banana</xsl:with-param>
						<xsl:with-param name="node" select="document('')/xsl:stylesheet/cxsltl:string.search/*"/>
					</xsl:call-template>
				</xsl:template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-01-11</xsltdoc:version>
		<xsltdoc:since>2014-12-24</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="変換される文字列"/>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="検索する値と置き換える値のノードセット"/>
		<xsltdoc:returnString xsltdoc:short="置換された文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.multipleReplace">
		<xsl:param name="string" select="."/>
		<xsl:param name="node" select="/.."/>

		<xsl:choose>
			<xsl:when test="$node">
				<xsl:call-template name="cxsltl:string.multipleReplace">
					<xsl:with-param name="node" select="$node[position() != 1]"/>
					<xsl:with-param name="string">
						<xsl:call-template name="cxsltl:string.replace">
							<xsl:with-param name="string" select="$string"/>
							<xsl:with-param name="src" select="$node[1]/@src"/>
							<xsl:with-param name="dst" select="$node[1]/@dst"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列を複数回再帰的に置換する</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is apple orange raspberry banana</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.multipleReplaceExtra">
					<xsl:with-param name="string">apple orange strawberry banana</xsl:with-param>
					<xsl:with-param name="replace">strawberry:blueberry,blueberry:blackberry,blackberry:raspberry</xsl:with-param>
					<xsl:with-param name="delimiter" select="','"/>
					<xsl:with-param name="subDelimiter" select="':'"/>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-02-11</xsltdoc:version>
		<xsltdoc:since>2015-02-11</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="置換される文字列"/>
		<xsltdoc:paramString xsltdoc:name="replace" xsltdoc:short="置換リスト"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="置換リストの区切り文字"/>
		<xsltdoc:paramString xsltdoc:name="subDelimiter" xsltdoc:short="置換前の文字と置換後の文字の区切り文字"/>
		<xsltdoc:returnString xsltdoc:short="置換された文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.multipleReplaceExtra">
		<xsl:param name="string" select="."/>
		<xsl:param name="replace"/>
		<xsl:param name="delimiter">,</xsl:param>
		<xsl:param name="subDelimiter">:</xsl:param>

		<xsl:choose>
			<xsl:when test="substring-after(substring-after($replace, $subDelimiter), $delimiter)">
				<xsl:call-template name="cxsltl:string.multipleReplaceExtra">
					<xsl:with-param name="string">
						<xsl:call-template name="cxsltl:string.replace">
							<xsl:with-param name="string" select="$string"/>
							<xsl:with-param name="src" select="substring-before($replace, $subDelimiter)"/>
							<xsl:with-param name="dst" select="substring-before(substring-after($replace, $subDelimiter), $delimiter)"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="replace" select="substring-after(substring-after($replace, $subDelimiter), $delimiter)"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
					<xsl:with-param name="subDelimiter" select="$subDelimiter"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="dst">
					<xsl:call-template name="cxsltl:string.substringAfter">
						<xsl:with-param name="string" select="$replace"/>
						<xsl:with-param name="substring" select="$subDelimiter"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:call-template name="cxsltl:string.replace">
					<xsl:with-param name="string" select="$string"/>
					<xsl:with-param name="src" select="substring-before($replace, $subDelimiter)"/>
					<xsl:with-param name="dst" select="$dst"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列を反復する</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is -=-=-=-=-=</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.repeat">
					<xsl:with-param name="string">-=</xsl:with-param>
					<xsl:with-param name="multiplier" select="5"/>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-06-25</xsltdoc:version>
		<xsltdoc:since>2015-01-11</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="反復を行う文字列"/>
		<xsltdoc:paramNumber xsltdoc:name="multiplier" xsltdoc:short="反復を行う回数"/>
		<xsltdoc:returnString xsltdoc:short="反復された文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.repeat">
		<xsl:param name="string" select="."/>
		<xsl:param name="multiplier" select="2"/>

		<xsl:if test="string($string) and 0 &lt; $multiplier">
			<xsl:call-template name="cxsltl:common.forLoop">
				<xsl:with-param name="callback" select="$cxsltl:string.self/xsl:template[@name = 'cxsltl:string.callback.repeat']"/>
				<xsl:with-param name="end" select="$multiplier"/>
				<xsl:with-param name="param1" select="$string"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>$param1の内容を表示する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="param1" xsltdoc:short="表示する文字列"/>
		<xsltdoc:returnString xsltdoc:short="$param1を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:string.callback.repeat']" mode="cxsltl:callback" name="cxsltl:string.callback.repeat">
		<xsl:param name="param1"/>

		<xsl:value-of select="$param1"/>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列を置換する</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is apple orange blueberry banana</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.replace">
					<xsl:with-param name="string">apple orange strawberry banana</xsl:with-param>
					<xsl:with-param name="src">strawberry</xsl:with-param>
					<xsl:with-param name="dst">blueberry</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-01-11</xsltdoc:version>
		<xsltdoc:since>2014-12-24</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="変換される文字列"/>
		<xsltdoc:paramString xsltdoc:name="src" xsltdoc:short="置換前の文字列"/>
		<xsltdoc:paramString xsltdoc:name="dst" xsltdoc:short="置換後の文字列"/>
		<xsltdoc:returnString xsltdoc:short="置換された文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.replace">
		<xsl:param name="string" select="."/>
		<xsl:param name="src"/>
		<xsl:param name="dst"/>

		<xsl:choose>
			<xsl:when test="string($src) and contains($string, $src)">
				<xsl:value-of select="concat(substring-before($string, $src), $dst)"/>

				<xsl:call-template name="cxsltl:string.replace">
					<xsl:with-param name="string" select="substring-after($string, $src)"/>
					<xsl:with-param name="src" select="$src"/>
					<xsl:with-param name="dst" select="$dst"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列の文末から空白を取り除く</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is " a b c"</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.rightTrim">
					<xsl:with-param name="string"> a b c </xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-01-15</xsltdoc:version>
		<xsltdoc:since>2015-01-15</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="入力文字列"/>
		<xsltdoc:paramString xsltdoc:name="charlist" xsltdoc:short="取り除く文字"/>
		<xsltdoc:paramString xsltdoc:name="except" xsltdoc:short="除外する文字"/>
		<xsltdoc:returnString xsltdoc:short="文末から空白が取り除かれた文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.rightTrim">
		<xsl:param name="string" select="."/>
		<xsl:param name="charlist" select="'&#x9;&#xA;&#xD; '"/>
		<xsl:param name="except"/>

		<xsl:variable name="right" select="substring($string, string-length($string), 1)"/>

		<xsl:choose>
			<xsl:when test="not(string($string)) or (translate($right, $charlist, '') and translate($right, $except, ''))">
				<xsl:value-of select="$string"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:string.rightTrim">
					<xsl:with-param name="string" select="substring($string, 1, string-length($string) - 1)"/>
					<xsl:with-param name="charlist" select="$charlist"/>
					<xsl:with-param name="except" select="$except"/>
				</xsl:call-template>

				<xsl:if test="not(translate($right, $except, ''))">
					<xsl:value-of select="$right"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列を任意の文字列で分割し、コールバックテンプレートを呼び出す</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is ["apple","orange","strawberry","banana"]</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:template match="/">
					<xsl:call-template name="cxsltl:string.split">
						<xsl:with-param name="callback" select="document('')/xsl:stylesheet/xsl:template[@name = 'cxsltl:string.callback.split']"/>
						<xsl:with-param name="string">apple, orange, strawberry, banana</xsl:with-param>
						<xsl:with-param name="delimiter" select="', '"/>
						<xsl:with-param name="param1">[</xsl:with-param>
						<xsl:with-param name="param2">]</xsl:with-param>
						<xsl:with-param name="param3">,</xsl:with-param>
					</xsl:call-template>
				</xsl:template>

				<xsl:template match="xsl:template[@name = 'cxsltl:string.callback.split']" mode="cxsltl:callback" name="cxsltl:string.callback.split">
					<xsl:param name="string"/>
					<xsl:param name="delimiter"/>
					<xsl:param name="position"/>
					<xsl:param name="count"/>
					<xsl:param name="original"/>
					<xsl:param name="param1"/>
					<xsl:param name="param2"/>
					<xsl:param name="param3"/>

					<xsl:if test="$position = 1">
						<xsl:value-of select="$param1"/>
					</xsl:if>

					<xsl:value-of select="concat('&quot;', $string, '&quot;')"/>

					<xsl:choose>
						<xsl:when test="$position = $count">
							<xsl:value-of select="$param2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$param3"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-01-11</xsltdoc:version>
		<xsltdoc:since>2014-12-24</xsltdoc:since>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックを適用するノードセット"/>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="分割する文字列"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="区切りの文字列"/>
		<xsltdoc:paramAny xsltdoc:name="param1" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param2" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param3" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param4" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param5" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:returnString xsltdoc:short="コールバックテンプレートから返ってきた値をそのまま返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.split">
		<xsl:param name="callback" select="."/>
		<xsl:param name="string" select="."/>
		<xsl:param name="delimiter" select="' '"/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>
		<xsl:param name="param4"/>
		<xsl:param name="param5"/>
		<xsl:param name="_position" select="1"/>
		<xsl:param name="_count">
			<xsl:call-template name="cxsltl:string.substringCount">
				<xsl:with-param name="string" select="$string"/>
				<xsl:with-param name="substring" select="$delimiter"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="_before"/>

		<xsl:choose>
			<xsl:when test="string($delimiter) and contains($string, $delimiter)">
				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="string" select="substring-before($string, $delimiter)"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
					<xsl:with-param name="position" select="$_position"/>
					<xsl:with-param name="count" select="$_count + 1"/>
					<xsl:with-param name="before" select="$_before"/>
					<xsl:with-param name="after" select="substring-after($string, $delimiter)"/>
					<xsl:with-param name="param1" select="$param1"/>
					<xsl:with-param name="param2" select="$param2"/>
					<xsl:with-param name="param3" select="$param3"/>
					<xsl:with-param name="param4" select="$param4"/>
					<xsl:with-param name="param5" select="$param5"/>
				</xsl:apply-templates>

				<xsl:call-template name="cxsltl:string.split">
					<xsl:with-param name="callback" select="$callback"/>
					<xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
					<xsl:with-param name="param1" select="$param1"/>
					<xsl:with-param name="param2" select="$param2"/>
					<xsl:with-param name="param3" select="$param3"/>
					<xsl:with-param name="param4" select="$param4"/>
					<xsl:with-param name="param5" select="$param5"/>
					<xsl:with-param name="_position" select="$_position + 1"/>
					<xsl:with-param name="_count" select="$_count"/>
					<xsl:with-param name="_before">
						<xsl:if test="$_position != 1">
							<xsl:value-of select="concat($_before, $delimiter)"/>
						</xsl:if>

						<xsl:value-of select="substring-before($string, $delimiter)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="string" select="$string"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
					<xsl:with-param name="position" select="$_position"/>
					<xsl:with-param name="count" select="$_count + 1"/>
					<xsl:with-param name="before" select="$_before"/>
					<xsl:with-param name="after"/>
					<xsl:with-param name="param1" select="$param1"/>
					<xsl:with-param name="param2" select="$param2"/>
					<xsl:with-param name="param3" select="$param3"/>
					<xsl:with-param name="param4" select="$param4"/>
					<xsl:with-param name="param5" select="$param5"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:string.callback.split']" mode="cxsltl:callback" name="cxsltl:string.callback.split">
		<xsl:param name="string"/>
		<xsl:param name="position"/>
		<xsl:param name="count"/>

		<xsl:text>"</xsl:text>

		<xsl:call-template name="cxsltl:string.replace">
			<xsl:with-param name="string" select="$string"/>
			<xsl:with-param name="src">"</xsl:with-param>
			<xsl:with-param name="dst">""</xsl:with-param>
		</xsl:call-template>

		<xsl:text>"</xsl:text>

		<xsl:if test="$position != $count">,</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列内の副文字列出現以後の文字列を返す</xsltdoc:short>
		<xsltdoc:detail>文字列内に副文字列が存在しなければ文字列をそのまま返す</xsltdoc:detail>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is prefix</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.substringAfter">
					<xsl:with-param name="string">xmlns:prefix</xsl:with-param>
					<xsl:with-param name="substring">:</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is xmlns</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.substringAfter">
					<xsl:with-param name="string">xmlns</xsl:with-param>
					<xsl:with-param name="substring">:</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-06-01</xsltdoc:version>
		<xsltdoc:since>2014-05-29</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="検索対象の文字列"/>
		<xsltdoc:paramString xsltdoc:name="substring" xsltdoc:short="検索する副文字列"/>
		<xsltdoc:returnString xsltdoc:short="文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.substringAfter">
		<xsl:param name="string" select="."/>
		<xsl:param name="substring" select="."/>

		<xsl:choose>
			<xsl:when test="string($substring) and contains($string, $substring)">
				<xsl:value-of select="substring-after($string, $substring)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列内の副文字列出現以前の文字列を返す</xsltdoc:short>
		<xsltdoc:detail>文字列内に副文字列が存在しなければ文字列をそのまま返す</xsltdoc:detail>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is xmlns</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.substringAfter">
					<xsl:with-param name="string">xmlns:prefix</xsl:with-param>
					<xsl:with-param name="substring">:</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is xmlns</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.substringAfter">
					<xsl:with-param name="string">xmlns</xsl:with-param>
					<xsl:with-param name="substring">:</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-06-01</xsltdoc:version>
		<xsltdoc:since>2014-05-29</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="検索対象の文字列"/>
		<xsltdoc:paramString xsltdoc:name="substring" xsltdoc:short="検索する副文字列"/>
		<xsltdoc:returnString xsltdoc:short="文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.substringBefore">
		<xsl:param name="string" select="."/>
		<xsl:param name="substring" select="."/>

		<xsl:choose>
			<xsl:when test="string($substring) and contains($string, $substring)">
				<xsl:value-of select="substring-before($string, $substring)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列内の副文字列の出現回数を数える</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is 2</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:string.substringCount">
					<xsl:with-param name="string">ABCABC</xsl:with-param>
					<xsl:with-param name="substring">BC</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-01-11</xsltdoc:version>
		<xsltdoc:since>2014-12-26</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="検索対象の文字列"/>
		<xsltdoc:paramString xsltdoc:name="substring" xsltdoc:short="検索する副文字列"/>
		<xsltdoc:returnString xsltdoc:short="出現回数"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:string.substringCount">
		<xsl:param name="string" select="."/>
		<xsl:param name="substring" select="."/>
		<xsl:param name="_count" select="0"/>

		<xsl:choose>
			<xsl:when test="string($substring) and contains($string, $substring)">
				<xsl:call-template name="cxsltl:string.substringCount">
					<xsl:with-param name="string" select="substring-after($string, $substring)"/>
					<xsl:with-param name="substring" select="$substring"/>
					<xsl:with-param name="_count" select="$_count + 1"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$_count"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>