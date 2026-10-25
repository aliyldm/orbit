package net.bigpoint.darkorbit.fui.builder.xml.creators.list
{
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollDirection;
   
   public class ItemGridCreator extends ItemListCreator
   {
      
      private static const dirMapping:Object = {};
      
      dirMapping["horizontal"] = ScrollDirection.DIRECTION_HORIZONTAL;
      dirMapping["vertical"] = ScrollDirection.DIRECTION_VERTICAL;
      
      public function ItemGridCreator()
      {
         super();
      }
      
      override protected function initializeAttributeMapping() : void
      {
         super.initializeAttributeMapping();
         this.attributeToMethodMap["direction"] = this.handleDirection;
      }
      
      override public function create(param1:XML) : ICoreponent
      {
         var _loc2_:Grid = new Grid();
         mapXMLNodeAttributes(_loc2_,param1);
         mapXMLChildrenToMethodHandler(_loc2_,param1);
         return _loc2_;
      }
      
      private function handleDirection(param1:ICoreponent, param2:String) : void
      {
         var _loc3_:Grid = param1 as Grid;
         _loc3_.scrollDirection = dirMapping.hasOwnProperty(param2) ? uint(dirMapping[param2]) : ScrollDirection.DIRECTION_HORIZONTAL;
      }
   }
}

