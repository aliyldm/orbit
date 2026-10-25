package net.bigpoint.darkorbit.gui.windows.components
{
   public class BarConfigVO
   {
      
      public static const FLASH_TYPE_BRIGHT:int = 0;
      
      public static const FLASH_TYPE_SECTOR_CONTROL:int = 0;
      
      public static const TEXTLAYOUT_VALUE_ONLY:String = "TEXTLAYOUT_VALUE_ONLY";
      
      public static const TEXTLAYOUT_VALUE_OF_TOTLA:String = "TEXTLAYOUT_VALUE_OF_TOTLA";
      
      private static const GAP:Number = 2;
      
      private const STD_BAR_HEIGHT:int = 6;
      
      private const STD_BAR_WIDTH:int = 70;
      
      public var gap:Number = 2;
      
      public var totalbarWidth:int = 70;
      
      public var totalbarHeight:int = 6;
      
      public var barColor:uint = 16711935;
      
      public var borderColor:uint = 0;
      
      public var backgroundColor:uint = 0;
      
      public var solidBackground:Boolean = true;
      
      public var flashType:int = 0;
      
      public var textlayout:String = "TEXTLAYOUT_VALUE_ONLY";
      
      public function BarConfigVO()
      {
         super();
      }
      
      public function clone() : BarConfigVO
      {
         var _loc1_:BarConfigVO = new BarConfigVO();
         _loc1_.gap = this.gap;
         _loc1_.totalbarWidth = this.totalbarWidth;
         _loc1_.totalbarHeight = this.totalbarHeight;
         _loc1_.barColor = this.barColor;
         _loc1_.borderColor = this.borderColor;
         _loc1_.backgroundColor = this.backgroundColor;
         _loc1_.solidBackground = this.solidBackground;
         _loc1_.flashType = this.flashType;
         _loc1_.textlayout = this.textlayout;
         return _loc1_;
      }
   }
}

