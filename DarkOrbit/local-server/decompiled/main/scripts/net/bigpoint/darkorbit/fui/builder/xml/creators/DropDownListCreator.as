package net.bigpoint.darkorbit.fui.builder.xml.creators
{
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.MappingInstanceNames;
   import net.bigpoint.darkorbit.fui.builder.repository.XMLUITemplateRepository;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.list.DropDownList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   
   public class DropDownListCreator extends AbstractCreator
   {
      
      public function DropDownListCreator()
      {
         super();
      }
      
      public function create(param1:XML) : ICoreponent
      {
         var _loc2_:ICoreponent = new DropDownList();
         mapXMLNodeAttributes(_loc2_,param1);
         mapXMLChildrenToMethodHandler(_loc2_,param1);
         return _loc2_;
      }
      
      override protected function initializeAttributeMapping() : void
      {
         super.initializeAttributeMapping();
         _nodeNameToMethodMap[MappingInstanceNames.ITEMLIST] = this.createItemList;
         _nodeNameToMethodMap["itemrenderer"] = this.createItemlistRenderer;
      }
      
      private function createItemList(param1:DropDownList, param2:XML) : void
      {
         var _loc3_:ItemList = UISystem.getInstance().builder.buildComponent(param2) as ItemList;
         param1.itemList = _loc3_;
      }
      
      protected function createItemlistRenderer(param1:DropDownList, param2:XML) : void
      {
         var _loc4_:XML = null;
         var _loc3_:String = param2.attribute(MappingInstanceNames.TEMPLATE);
         if(_loc3_)
         {
            _loc4_ = XMLUITemplateRepository.getInstance().getTemplateByName(_loc3_) as XML;
            if(_loc4_)
            {
               param1.itemRendererTemplate = _loc4_;
            }
            else
            {
               UISystem.log("No registered template structure found for : " + _loc3_);
            }
         }
         else
         {
            param1.itemRendererTemplate = param2;
         }
      }
   }
}

