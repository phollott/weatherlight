<!--

    IBM Confidential OCO Source Materials

    5725-G92 Copyright IBM Corp. 2006, 2013

    The source code for this program is not published or otherwise
    divested of its trade secrets, irrespective of what has
    been deposited with the U.S. Copyright Office.

-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns="urn:schemas-microsoft-com:office:spreadsheet"
				xmlns:o="urn:schemas-microsoft-com:office:office"
				xmlns:x="urn:schemas-microsoft-com:office:excel"
				xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"
				xmlns:s="uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882"
				xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema"
				xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
				xmlns:html="http://www.w3.org/TR/REC-html40">
    <xsl:output method="text"/>

    <xsl:template match="/">
 		<xsl:apply-templates select="//ss:Worksheet[@ss:Name='Key Deals - For Revenue Calls']"/>
    </xsl:template>

    <xsl:template match="ss:Worksheet">
        {
        	'name': '<xsl:value-of select="@ss:Name"/>',
         	'children': [
         		<xsl:apply-templates mode="market" select="ss:Table/ss:Row[position() &gt; 9]"/>
        	]
        }
    </xsl:template>
    
    <xsl:template match="ss:Row" mode="market">
		<xsl:variable name="count" select="count(ss:Cell)"/>    
		<xsl:variable name="market" select="ss:Cell[1]/ss:Data/text()"/>    
		<xsl:choose>
			<!-- always ignore totals, short rows, rows with no text -->
			<xsl:when test="contains($market, 'Total')"></xsl:when>
			<xsl:when test="$count &lt; 7"></xsl:when>
			<xsl:when test="not(ss:Cell[1]/ss:Data)"></xsl:when>
			<xsl:otherwise>
				<xsl:variable name="sibs">
					<xsl:apply-templates mode="market-duration" select="./following-sibling::ss:Row"/>
				</xsl:variable>
        		<xsl:variable name="duration" select="number(substring-before($sibs, ':'))"/>
        {
        	'name': '<xsl:value-of select="ss:Cell[1]/ss:Data/text()"/>',
         	'children': [
         		<xsl:apply-templates mode="probability" select=". | ./following-sibling::ss:Row[position() &lt; $duration]"/>
        	]
        },
			</xsl:otherwise>
		</xsl:choose>    
    </xsl:template>
    
    <xsl:template mode="market-duration" match="ss:Row">
    	<xsl:variable name="count" select="count(ss:Cell)"/>    
		<xsl:variable name="market" select="ss:Cell[1]/ss:Data/text()"/>    
		<xsl:choose>
			<!-- always ignore totals, short rows, rows with no text -->
			<xsl:when test="contains($market, 'Total')"></xsl:when>
			<xsl:when test="$count &lt; 7"></xsl:when>
			<xsl:when test="not(ss:Cell[1]/ss:Data)"></xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="position()"/>:
			</xsl:otherwise>
		</xsl:choose>        
    </xsl:template>
    
    <xsl:template match="ss:Row" mode="probability">
		<xsl:variable name="count" select="count(ss:Cell)"/>    
		<xsl:variable name="market" select="ss:Cell[1]/ss:Data/text()"/>    
		<xsl:variable name="probability" select="ss:Cell[2]/ss:Data/text()"/>    
		<xsl:choose>
			<!-- always ignore totals, short rows, rows with no text -->
			<xsl:when test="contains($market, 'Total')"></xsl:when>
			<xsl:when test="$count = 6 and contains(ss:Cell[1]/ss:Data/text(), '%')">
				<xsl:variable name="sibs">
					<xsl:apply-templates mode="probability-duration" select="./following-sibling::ss:Row"/>
				</xsl:variable>
        		<xsl:variable name="duration" select="number(substring-before($sibs, ':'))"/>
        {
        	'name': '<xsl:value-of select="ss:Cell[1]/ss:Data/text()"/>',
         	'children': [
         		<xsl:apply-templates mode="remainder" select=". | ./following-sibling::ss:Row[position() &lt; $duration]"/>
        	]
        },
			</xsl:when>
			<xsl:when test="not(ss:Cell[2]/ss:Data)"></xsl:when>
			<xsl:otherwise>
				<xsl:if test="contains(ss:Cell[2]/ss:Data/text(), '%')">
					<xsl:variable name="sibs">
						<xsl:apply-templates mode="probability-duration" select="./following-sibling::ss:Row"/>
					</xsl:variable>
	        		<xsl:variable name="duration" select="number(substring-before($sibs, ':'))"/>
        {
        	'name': '<xsl:value-of select="ss:Cell[2]/ss:Data/text()"/>',
         	'children': [
         		<xsl:apply-templates mode="remainder" select=". | ./following-sibling::ss:Row[position() &lt; $duration]"/>
        	]
        },
        		</xsl:if>
        	</xsl:otherwise>
        </xsl:choose>
	</xsl:template>    

    <xsl:template mode="probability-duration" match="ss:Row">
    	<xsl:variable name="count" select="count(ss:Cell)"/>    
		<xsl:variable name="market" select="ss:Cell[1]/ss:Data/text()"/>    
		<xsl:variable name="probability" select="ss:Cell[2]/ss:Data/text()"/>    
		<xsl:choose>
			<!-- always ignore totals, rows with no text -->
			<xsl:when test="contains($market, 'Total')"></xsl:when>
			<xsl:when test="$count = 6 and ss:Cell[1]/ss:Data">
				<xsl:value-of select="position()"/>:
			</xsl:when>
			<xsl:when test="not(ss:Cell[2]/ss:Data)"></xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="position()"/>:
			</xsl:otherwise>
		</xsl:choose>        
    </xsl:template>

   <xsl:template match="ss:Row" mode="remainder">
		<xsl:variable name="count" select="count(ss:Cell)"/>    
		<xsl:variable name="market" select="ss:Cell[1]/ss:Data/text()"/>    
		<xsl:variable name="opportunity" select="ss:Cell[3]/ss:Data/text()"/>    
		<xsl:if test="not(contains($market, 'Total'))">
        {
        	'title': '<xsl:call-template name="join"><xsl:with-param name="list" select="ss:Cell/ss:Data/text()"/></xsl:call-template>',
		<xsl:choose>
			<xsl:when test="$count &gt; 7">
        	'name': '<xsl:value-of select="ss:Cell[$count - 5]/ss:Data/text()"/>',
        	'q2size': '<xsl:value-of select="ss:Cell[$count - 3]/ss:Data/text()"/>',
        	'q3size': '<xsl:value-of select="ss:Cell[$count - 2]/ss:Data/text()"/>',
        	'size': '<xsl:value-of select="ss:Cell[$count - 1]/ss:Data/text()"/>',
			</xsl:when>
			<xsl:otherwise>
        	'name': '<xsl:value-of select="ss:Cell[$count - 4]/ss:Data/text()"/>',
        	'q2size': '<xsl:value-of select="ss:Cell[$count - 2]/ss:Data/text()"/>',
        	'q3size': '<xsl:value-of select="ss:Cell[$count - 1]/ss:Data/text()"/>',
        	'size': '<xsl:value-of select="ss:Cell[$count]/ss:Data/text()"/>',
        	</xsl:otherwise>
        </xsl:choose>
        },
        </xsl:if>
	</xsl:template>    

	<xsl:template name="join" >	
	    <xsl:param name="list" select="''"/>
	    <xsl:param name="del" select="','"/>	
	    <xsl:for-each select="$list">
	      <xsl:choose>	
	        <xsl:when test="position() = 1">
	          <xsl:value-of select="."/>
	        </xsl:when>	
	        <xsl:otherwise>
	          <xsl:value-of select="concat($del, .) "/>
	        </xsl:otherwise>	
	      </xsl:choose>
	    </xsl:for-each>
	  </xsl:template>

<!-- when row has 6 cells, use opportunity=3 -->
<!-- when row has 7 cells, use opportunity=3 -->
    <xsl:template match="ss:Row" mode="opportunity">
		<xsl:variable name="count" select="count(ss:Cell)"/>    
		<xsl:variable name="oppfix" select="count(ss:Cell)-3"/>    
		<xsl:variable name="market" select="ss:Cell[1]/ss:Data/text()"/>    
		<xsl:choose>
			<xsl:when test="contains($market, 'Total')"></xsl:when>
 			<xsl:when test="$count &lt; 7">
				<xsl:variable name="opportunity" select="ss:Cell[$oppfix]/ss:Data/text()"/>    
        {
        	'count': '<xsl:value-of select="$count"/>',
        	'name': '<xsl:value-of select="$opportunity"/>',
         	'children': [
        	]
        },
			
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="opportunity" select="ss:Cell[4]/ss:Data/text()"/>    
        {
        	'count': '<xsl:value-of select="$count"/>',
        	'name': '<xsl:value-of select="$opportunity"/>',
         	'children': [
        	]
        },
			</xsl:otherwise>
		</xsl:choose>
    </xsl:template>

    <xsl:template match="ss:Row" mode="project">
		<xsl:variable name="projectName" select="ss:Cell[2]/ss:Data/text()"/>    
		<xsl:variable name="projectCode" select="ss:Cell[3]/ss:Data/text()"/>    
		<xsl:variable name="projectNet" select="ss:Cell[4]/ss:Data/text()"/>    
        {
        	'name': '<xsl:value-of select="$projectCode"/>',
        	'long': '<xsl:value-of select="$projectName"/>',
        	'size': '<xsl:value-of select="$projectNet"/>'
        },
    </xsl:template>


    <xsl:template match="ss:Data">
        {
        	'test': '<xsl:value-of select="text()"/>'
        },
    </xsl:template>


</xsl:stylesheet>
