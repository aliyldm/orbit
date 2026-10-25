package net.bigpoint.darkorbit.fui.builder.xml.creators.slideshow
{
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.MappingInstanceNames;
   import net.bigpoint.darkorbit.fui.builder.repository.XMLUITemplateRepository;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.AbstractCreator;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.list.slideshow.ItemSlideShow;
   
   public class ItemSlideShowCreator extends AbstractCreator
   {
      
      public function ItemSlideShowCreator()
      {
         super();
      }
      
      override protected function initializeAttributeMapping() : void
      {
         super.initializeAttributeMapping();
         _nodeNameToMethodMap["itemrenderer"] = this.createItemRenderer;
      }
      
      public function create(param1:XML) : ICoreponent
      {
         var _loc2_:ItemSlideShow = new ItemSlideShow();
         mapXMLNodeAttributes(_loc2_,param1);
         mapXMLChildrenToMethodHandler(_loc2_,param1);
         return _loc2_;
      }
      
      protected function createItemRenderer(param1:ItemSlideShow, param2:XML) : void
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

