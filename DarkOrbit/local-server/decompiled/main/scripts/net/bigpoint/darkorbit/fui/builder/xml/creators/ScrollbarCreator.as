package net.bigpoint.darkorbit.fui.builder.xml.creators
{
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollDirection;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   
   public class ScrollbarCreator extends AbstractCreator
   {
      
      private static const dirMapping:Object = {};
      
      dirMapping["horizontal"] = ScrollDirection.DIRECTION_HORIZONTAL;
      dirMapping["vertical"] = ScrollDirection.DIRECTION_VERTICAL;
      
      public function ScrollbarCreator()
      {
         super();
      }
      
      override protected function initializeAttributeMapping() : void
      {
         super.initializeAttributeMapping();
         this.attributeToMethodMap["direction"] = this.handleDirection;
         this.attributeToMethodMap["scrollSpeed"] = this.handleScrollSpeed;
      }
      
      private function handleDirection(param1:ICoreponent, param2:String) : void
      {
         var _loc3_:Scrollbar = param1 as Scrollbar;
         _loc3_.scrollDirection = dirMapping.hasOwnProperty(param2) ? uint(dirMapping[param2]) : ScrollDirection.DIRECTION_HORIZONTAL;
      }
      
      private function handleScrollSpeed(param1:ICoreponent, param2:String) : void
      {
         var _loc3_:Scrollbar = param1 as Scrollbar;
         _loc3_.scrollPixelSpeed = parseInt(param2);
      }
      
      public function create(param1:XML) : ICoreponent
      {
         var _loc2_:Scrollbar = new Scrollbar();
         mapXMLNodeAttributes(_loc2_,param1);
         return _loc2_;
      }
   }
}

