<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>バイナリを扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2015-11-18</xsltdoc:version>
		<xsltdoc:since>2015-05-20</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>バイナリかどうか検査する</xsltdoc:short>
		<xsltdoc:version>2015-11-18</xsltdoc:version>
		<xsltdoc:since>2015-05-20</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="binary" xsltdoc:short="0と1で構成された文字列"/>
		<xsltdoc:paramBooleanString xsltdoc:name="message" xsltdoc:short="true()ならばエラーメッセージを表示する"/>
		<xsltdoc:return xsltdoc:short="演算結果がtrueならば1を、falseならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:binary.validate">
		<xsl:param name="binary" select="."/>
		<xsl:param name="message" select="false()"/>

		<xsl:choose>
			<xsl:when test="not(string($binary)) or translate($binary, '01', '')">
				<xsl:choose>
					<xsl:when test="number($message) = 1 and string($message) = 'true'">
						<xsl:message terminate="yes">cxsltl:binary.validate: $binary is only a 0 or 1.</xsl:message>
					</xsl:when>
					<xsl:when test="$message">
						<xsl:message terminate="yes">
							<xsl:value-of select="$message"/>
						</xsl:message>
					</xsl:when>
				</xsl:choose>

				<xsl:text>0</xsl:text>
			</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>隣のビットとビット演算を行う</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is 0</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:binary.bitOperationInNextBit">
					<xsl:with-param name="binary">101</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is 1</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:binary.bitOperationInNextBit">
					<xsl:with-param name="binary">010</xsl:with-param>
					<xsl:with-param name="operation">or</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is 1</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:binary.bitOperationInNextBit">
					<xsl:with-param name="binary">100</xsl:with-param>
					<xsl:with-param name="operation">xor</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-11-18</xsltdoc:version>
		<xsltdoc:since>2015-05-20</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="binary" xsltdoc:short="0と1で構成された文字列"/>
		<xsltdoc:paramString xsltdoc:name="operation" xsltdoc:short="'and', 'or', 'nand', 'nor', 'xor', 'xnor'の何れかの値"/>
		<xsltdoc:return xsltdoc:short="演算結果がtrueならば1を、falseならば0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:binary.bitOperationInNextBit">
		<xsl:param name="binary" select="."/>
		<xsl:param name="operation">and</xsl:param>

		<xsl:variable name="valid">
			<xsl:call-template name="cxsltl:binary.validate">
				<xsl:with-param name="binary" select="$binary"/>
				<xsl:with-param name="message">cxsltl:binary.bitOperationInNextBit: $binary is only a 0 or 1.</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$valid = '0'">0</xsl:when>
			<xsl:when test="string-length($binary) &lt; 2">
				<xsl:message terminate="yes">cxsltl:binary.bitOperationInNextBit: Minimum length of $binary is 2.</xsl:message>

				<xsl:text>0</xsl:text>
			</xsl:when>
			<xsl:when test="$operation != 'and' and $operation != 'or' and $operation != 'nand' and $operation != 'nor' and $operation != 'xor' and $operation != 'xnor'">
				<xsl:message terminate="yes">cxsltl:binary.bitOperationInNextBit: $operation is only a "and" or "or" or "nand" or "nor" or "xor" or "xnor".</xsl:message>

				<xsl:text>0</xsl:text>
			</xsl:when>
			<xsl:when test="
				($operation = 'and' and not(contains($binary, '0'))) or
				($operation = 'or' and contains($binary, '1')) or
				($operation = 'nand' and contains($binary, '0')) or
				($operation = 'nor' and not(contains($binary, '1'))) or
				($operation = 'xor' and string-length(translate($binary, '0', '')) mod 2 = 1) or
				($operation = 'xnor' and string-length(translate($binary, '0', '')) mod 2 = 0)
			">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>