//+------------------------------------------------------------------+
//|                                                 Geo_InnerBar.mq5 |
//|                                  Copyright � 2012, Geokom FX Lab |
//|                                             geokom2004@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2012, Geokom"
#property link      "geokom2004@yandex.ru"
//--- ����� ������ ����������
#property version   "1.00"
//--- ��������� ���������� � ��������� ����
#property indicator_separate_window 
//--- ���������� ������������ ������� 1
#property indicator_buffers 1 
//--- ������������ ���� ����������� ����������
#property indicator_plots   1
//--- ������ � ������� ����������� ����� ���������� ���� ����������
#property indicator_maximum +1.1
#property indicator_minimum +0.0
//+-----------------------------------+
//| ��������� ��������� ����������    |
//+-----------------------------------+
//--- ��������� ���������� � ���� �����������
#property indicator_type1   DRAW_HISTOGRAM
//--- � �������� ����� ����� ���������� ����������� Coral ����
#property indicator_color1 clrCoral
//--- ����� ���������� - ����������� ������
#property indicator_style1  STYLE_SOLID
//--- ������� ����� ���������� ����� 3
#property indicator_width1  3
//--- ����������� ����� ����������
#property indicator_label1  "Geo_InnerBar"
//+-----------------------------------+
//| ���������� ��������               |
//+-----------------------------------+
#define RESET 0 // ��������� ��� �������� ��������� ������� �� �������� ����������
//+-----------------------------------+
//--- ���������� ������������ ��������, ������� �����
//--- � ���������� ������������ � �������� ������������ �������
double ExtBuffer[];
//--- ���������� ������������� ���������� ������ ������� ������
int  min_rates_total;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- ������������� ���������� ������ ������� ������
   min_rates_total=int(2);
//--- ����������� ������������� ������� � ������������ �����
   SetIndexBuffer(0,ExtBuffer,INDICATOR_DATA);
//--- ���������� ��������� � ������ ��� � ���������
   ArraySetAsSeries(ExtBuffer,true);
//--- ������������� ������ ������ ������� ��������� ����������
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,min_rates_total);
//--- ��������� �������� ����������, ������� �� ����� ������ �� �������
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0.0);
//--- �������� ����� ��� ����������� � ��������� ������� � �� ����������� ���������
   IndicatorSetString(INDICATOR_SHORTNAME,"Geo_InnerBar");
//--- ����������� �������� ����������� �������� ����������
   IndicatorSetInteger(INDICATOR_DIGITS,0);
//--- ���������� �������������
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+  
//| Custom indicator iteration function                              | 
//+------------------------------------------------------------------+  
int OnCalculate(const int rates_total,    // ���������� ������� � ����� �� ������� ����
                const int prev_calculated,// ���������� ������� � ����� �� ���������� ����
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//--- �������� ���������� ����� �� ������������� ��� �������
   if(rates_total<min_rates_total) return(RESET);
//--- ���������� ��������� ���������� 
   int limit,bar;
//--- ���������� ��������� � �������� ��� � ����������  
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
//--- ������� ������������ ���������� ���������� ������
//--- � ���������� ������ limit ��� ����� ��������� �����
   if(prev_calculated>rates_total || prev_calculated<=0)// �������� �� ������ ����� ������� ����������
     {
      limit=rates_total-min_rates_total-1; // ��������� ����� ��� ������� ���� �����
     }
   else limit=rates_total-prev_calculated; // ��������� ����� ��� ������� ����� �����
//--- ������ ���� ������� ����������
   for(bar=limit; bar>=0 && !IsStopped(); bar--)
     {
      if(high[bar]<high[bar+1] && low[bar]>low[bar+1]) ExtBuffer[bar]=1;
      else ExtBuffer[bar]=0.0;
     }
//---    
   return(rates_total);
  }
//+------------------------------------------------------------------+
