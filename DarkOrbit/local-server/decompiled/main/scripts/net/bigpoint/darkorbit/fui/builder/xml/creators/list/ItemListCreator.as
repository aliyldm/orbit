package net.bigpoint.darkorbit.fui.builder.xml.creators.list
{
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.MappingInstanceNames;
   import net.bigpoint.darkorbit.fui.builder.repository.XMLUITemplateRepository;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.AbstractCreator;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.GridItemListLayout;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.layouts.CenteredHorizontalListLayout;
   import net.bigpoint.darkorbit.fui.components.list.layouts.HorizontalItemListLayout;
   import net.bigpoint.darkorbit.fui.components.list.layouts.VerticalItemListLayout;
   
   public class ItemListCreator extends AbstractCreator
   {
      
      public function ItemListCreator()
      {
         super();
      }
      
      override protected function initializeAttributeMapping() : void
      {
         super.initializeAttributeMapping();
         attributeToMethodMap["layout"] = this.assignItemlistLayout;
         attributeToMethodMap["allowDeselection"] = this.assignAllowDeselection;
         _nodeNameToMethodMap["itemrenderer"] = this.createItemlistRenderer;
      }
      
      protected function assignAllowDeselection(param1:ItemList, param2:String) : void
      {
         if(param2 == "true")
         {
            param1.allowDeselection = true;
         }
      }
      
      public function create(param1:XML) : ICoreponent
      {
         var _loc2_:ItemList = new ItemList();
         mapXMLNodeAttributes(_loc2_,param1);
         mapXMLChildrenToMethodHandler(_loc2_,param1);
         return _loc2_;
      }
      
      protected function createItemlistRenderer(param1:ItemList, param2:XML) : void
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
      
      protected function assignItemlistLayout(param1:ItemList, param2:String) : void
      {
         switch(param2)
         {
            case "vertical":
               param1.layout = new VerticalItemListLayout();
               break;
            case "horizontal":
               param1.layout = new HorizontalItemListLayout();
               break;
            case "horizontal_centered":
               param1.layout = new CenteredHorizontalListLayout();
               break;
            case "grid":
               param1.layout = new GridItemListLayout();
         }
      }
   }
}

