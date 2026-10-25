package net.bigpoint.darkorbit.fui.builder.xml.creators
{
   import com.adobe.serialization.json.JSON;
   import flash.filters.BitmapFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextFieldAutoSize;
   import flashx.textLayout.formats.TextAlign;
   import net.bigpoint.darkorbit.fui.builder.repository.FilterRepository;
   import net.bigpoint.darkorbit.fui.builder.repository.TextStyleRepository;
   import net.bigpoint.darkorbit.fui.builder.repository.TextStyleVO;
   
   public class TextStyleCreator extends AbstractCreator
   {
      
      public function TextStyleCreator()
      {
         super();
      }
      
      override protected function initializeAttributeMapping() : void
      {
         super.initializeAttributeMapping();
         this.attributeToMethodMap["autoSize"] = this.handleAutoSizeAttribute;
         this.attributeToMethodMap["align"] = this.handleAlignAttribute;
         this.attributeToMethodMap["glowFilter"] = this.handleGlowFilterAttribute;
         this.attributeToMethodMap["dropShadow"] = this.handleDropShadowAttribute;
      }
      
      private function handleAlignAttribute(param1:Object, param2:String) : void
      {
         param2 = param2.toLowerCase();
         var _loc3_:TextStyleVO = param1 as TextStyleVO;
         switch(param2)
         {
            case TextAlign.LEFT:
            case TextAlign.RIGHT:
            case TextAlign.CENTER:
            case TextAlign.JUSTIFY:
            case TextAlign.END:
            case TextAlign.START:
               _loc3_.align = param2;
         }
      }
      
      private function handleGlowFilterAttribute(param1:Object, param2:String) : void
      {
         var _loc3_:TextStyleVO = param1 as TextStyleVO;
         var _loc4_:RegExp = /\"|\:|\ |\,|\{|\}|\\n|\\r/g;
         var _loc5_:String = param2.toLowerCase().replace(_loc4_,"");
         var _loc6_:GlowFilter = FilterRepository.getInstance().getByKey(_loc5_) as GlowFilter;
         if(_loc6_ != null)
         {
            _loc3_.glowFilter = _loc6_;
            return;
         }
         _loc6_ = new GlowFilter();
         _loc6_ = this.populateFilter(_loc6_,param2) as GlowFilter;
         FilterRepository.getInstance().register(_loc5_,_loc6_);
         _loc3_.glowFilter = _loc6_;
      }
      
      private function handleDropShadowAttribute(param1:Object, param2:String) : void
      {
         var _loc3_:TextStyleVO = param1 as TextStyleVO;
         var _loc4_:RegExp = /\"|\:|\ |\,|\{|\}|\\n|\\r/g;
         var _loc5_:String = param2.toLowerCase().replace(_loc4_,"");
         var _loc6_:DropShadowFilter = FilterRepository.getInstance().getByKey(_loc5_) as DropShadowFilter;
         if(_loc6_ != null)
         {
            _loc3_.dropShadow = _loc6_;
            return;
         }
         _loc6_ = new DropShadowFilter();
         _loc6_ = this.populateFilter(_loc6_,param2) as DropShadowFilter;
         FilterRepository.getInstance().register(_loc5_,_loc6_);
         _loc3_.dropShadow = _loc6_;
      }
      
      private function populateFilter(param1:BitmapFilter, param2:String) : BitmapFilter
      {
         var _loc4_:* = undefined;
         var _loc3_:Object = com.adobe.serialization.json.JSON.decode(param2);
         for(_loc4_ in _loc3_)
         {
            param1[_loc4_] = _loc3_[_loc4_];
         }
         return param1;
      }
      
      public function create(param1:XML) : TextStyleVO
      {
         var _loc2_:TextStyleVO = new TextStyleVO("null");
         mapXMLNodeAttributes(_loc2_,param1);
         TextStyleRepository.getInstance().register(_loc2_);
         return _loc2_;
      }
      
      protected function handleAutoSizeAttribute(param1:Object, param2:String) : void
      {
         param2 = param2.toLowerCase();
         var _loc3_:TextStyleVO = param1 as TextStyleVO;
         switch(param2)
         {
            case TextFieldAutoSize.LEFT:
            case TextFieldAutoSize.RIGHT:
            case TextFieldAutoSize.CENTER:
            case TextFieldAutoSize.NONE:
               _loc3_.autoSize = param2;
         }
      }
   }
}

