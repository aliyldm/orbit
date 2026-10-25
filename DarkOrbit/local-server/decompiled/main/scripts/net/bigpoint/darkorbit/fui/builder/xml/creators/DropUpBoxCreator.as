package net.bigpoint.darkorbit.fui.builder.xml.creators
{
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.list.dropupbox.DropUpBox;
   
   public class DropUpBoxCreator extends AbstractCreator
   {
      
      public function DropUpBoxCreator()
      {
         super();
      }
      
      public function create(param1:XML) : ICoreponent
      {
         var _loc2_:ICoreponent = new DropUpBox();
         mapXMLNodeAttributes(_loc2_,param1);
         return _loc2_;
      }
      
      override protected function initializeAttributeMapping() : void
      {
         super.initializeAttributeMapping();
         attributeToMethodMap["entries"] = this.handleEntries;
         attributeToMethodMap["locaLib"] = this.handleLoca;
      }
      
      private function handleEntries(param1:ICoreponent, param2:String) : void
      {
         var _loc3_:DropUpBox = param1 as DropUpBox;
         var _loc4_:Array = param2.split(",");
         var _loc5_:Vector.<String> = new Vector.<String>(0);
         _loc5_ = _loc5_.concat(_loc4_);
         _loc3_.updateAvailableEntries(_loc5_);
      }
      
      private function handleLoca(param1:ICoreponent, param2:String) : void
      {
         var _loc3_:DropUpBox = param1 as DropUpBox;
         _loc3_.locaCategory = param2;
      }
   }
}

