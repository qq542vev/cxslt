<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>ベースとなるスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2015-11-18</xsltdoc:version>
		<xsltdoc:since>2014-12-29</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:decimal-format
		name="cxsltl:common.numberFormat"
		decimal-separator="."
		grouping-separator=","
		infinity="Infinity"
		minus-sign="-"
		NaN="NaN"
		percent="%"
		per-mille="‰"
		zero-digit="0"
		digit="#"
		pattern-separator=";"
	/>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:common.self" select="document('')/xsl:stylesheet"/>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>trueになる値を選択して出力する</xsltdoc:short>
		<xsltdoc:detail>$test0 - $test4を順次チェックし、boolean($test)がtrueならば、その値を出力する。</xsltdoc:detail>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is "Name is none."</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:template match="/">
					<xsl:call-template name="cxsltl:common.chooseAndPrint">
						<xsl:with-param name="test0" select="name()"/>
						<xsl:with-param name="test1">Name is none.</xsl:with-param>
					</xsl:call-template>
				</xsl:template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-05-09</xsltdoc:version>
		<xsltdoc:since>2015-05-09</xsltdoc:since>
		<xsltdoc:paramAny xsltdoc:name="test0" xsltdoc:short="チェックし出力する値1"/>
		<xsltdoc:paramAny xsltdoc:name="test1" xsltdoc:short="チェックし出力する値2"/>
		<xsltdoc:paramAny xsltdoc:name="test2" xsltdoc:short="チェックし出力する値3"/>
		<xsltdoc:paramAny xsltdoc:name="test3" xsltdoc:short="チェックし出力する値4"/>
		<xsltdoc:paramAny xsltdoc:name="test4" xsltdoc:short="チェックし出力する値5"/>
		<xsltdoc:return xsltdoc:short="trueになった値"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:common.chooseAndPrint">
		<xsl:param name="test0"/>
		<xsl:param name="test1"/>
		<xsl:param name="test2"/>
		<xsl:param name="test3"/>
		<xsl:param name="test4"/>

		<xsl:choose>
			<xsl:when test="$test0">
				<xsl:copy-of select="$test0"/>
			</xsl:when>
			<xsl:when test="$test1">
				<xsl:copy-of select="$test1"/>
			</xsl:when>
			<xsl:when test="$test2">
				<xsl:copy-of select="$test2"/>
			</xsl:when>
			<xsl:when test="$test3">
				<xsl:copy-of select="$test3"/>
			</xsl:when>
			<xsl:when test="$test4">
				<xsl:copy-of select="$test4"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>ある範囲内の数を生成し、コールバックテンプレートを呼び出す</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is 0 1 2 3 4 5 6 7 8 9</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:template match="/">
					<xsl:call-template name="cxsltl:common.forLoop">
						<xsl:with-param name="callback" select="document('')/xsl:stylesheet/xsl:template[@name = 'cxsltl:common.callback.forLoop']"/>
						<xsl:with-param name="start" select="0"/>
						<xsl:with-param name="end" select="9"/>
					</xsl:call-template>
				</xsl:template>

				<xsl:template match="xsl:template[@name = 'cxsltl:common.callback.forLoop']" mode="cxsltl:callback" name="cxsltl:common.callback.forLoop">
					<xsl:param name="start"/>
					<xsl:param name="end"/>
					<xsl:param name="step"/>
					<xsl:param name="position"/>

					<xsl:value-of select="concat($position, ' ')"/>
				</xsl:template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-11-18</xsltdoc:version>
		<xsltdoc:since>2014-12-29</xsltdoc:since>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックを適用するノードセット"/>
		<xsltdoc:paramNumber xsltdoc:name="start" xsltdoc:short="ループの最初の番号"/>
		<xsltdoc:paramNumber xsltdoc:name="end" xsltdoc:short="ループの番号の最大値"/>
		<xsltdoc:paramNumber xsltdoc:name="step" xsltdoc:short="ループの番号の増加数"/>
		<xsltdoc:paramAny xsltdoc:name="param1" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param2" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param3" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param4" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param5" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:return xsltdoc:short="コールバックテンプレートから返ってきた値をそのまま返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:common.forLoop">
		<xsl:param name="callback" select="$cxsltl:common.self/xsl:template[@name = 'cxsltl:common.callback.forLoop']"/>
		<xsl:param name="start" select="1"/>
		<xsl:param name="end" select="100"/>
		<xsl:param name="step" select="1"/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>
		<xsl:param name="param4"/>
		<xsl:param name="param5"/>
		<xsl:param name="_position" select="$start"/>
		<xsl:param name="_counter" select="1"/>

		<xsl:if test="$_position &lt;= $end">
			<xsl:apply-templates select="$callback" mode="cxsltl:callback">
				<xsl:with-param name="start" select="$start"/>
				<xsl:with-param name="end" select="$end"/>
				<xsl:with-param name="step" select="$step"/>
				<xsl:with-param name="position" select="$_position"/>
				<xsl:with-param name="counter" select="$_counter"/>
				<xsl:with-param name="param1" select="$param1"/>
				<xsl:with-param name="param2" select="$param2"/>
				<xsl:with-param name="param3" select="$param3"/>
				<xsl:with-param name="param4" select="$param4"/>
				<xsl:with-param name="param5" select="$param5"/>
			</xsl:apply-templates>

			<xsl:call-template name="cxsltl:common.forLoop">
				<xsl:with-param name="callback" select="$callback"/>
				<xsl:with-param name="start" select="$start"/>
				<xsl:with-param name="end" select="$end"/>
				<xsl:with-param name="step" select="$step"/>
				<xsl:with-param name="param1" select="$param1"/>
				<xsl:with-param name="param2" select="$param2"/>
				<xsl:with-param name="param3" select="$param3"/>
				<xsl:with-param name="param4" select="$param4"/>
				<xsl:with-param name="param5" select="$param5"/>
				<xsl:with-param name="_position" select="$_position + $step"/>
				<xsl:with-param name="_counter" select="$_counter + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>cxsltl:common.forLoopのデフォルトのコールバックテンプレート</xsltdoc:short>
		<xsltdoc:version>2015-11-18</xsltdoc:version>
		<xsltdoc:since>2015-11-18</xsltdoc:since>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="現在の数値"/>
		<xsltdoc:paramNumber xsltdoc:name="end" xsltdoc:short="ループの番号の最大値"/>
		<xsltdoc:paramNumber xsltdoc:name="step" xsltdoc:short="ループの番号の増加数"/>
		<xsltdoc:return xsltdoc:short="現在の数値を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:common.callback.forLoop']" mode="cxsltl:callback" name="cxsltl:common.callback.forLoop">
		<xsl:param name="position" select="1"/>
		<xsl:param name="end" select="1"/>
		<xsl:param name="step" select="1"/>

		<xsl:value-of select="$position"/>

		<xsl:if test="($position + $step) &lt;= $end">
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>