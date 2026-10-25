package net.bigpoint.darkorbit.fui.builder.xml.creators
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.builder.repository.UIInstanceRepository;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.scroll.IScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.system.utils.BindingsUtils;
   
   public class BindingCreator extends AbstractCreator
   {
      
      public static var SCROLL_BAR_CONTAINER:String = "scrollcontainer";
      
      private static var typeToMethodMap:Dictionary = new Dictionary();
      
      private var _source:String;
      
      private var _target:String;
      
      private var _type:String;
      
      public function BindingCreator()
      {
         super();
      }
      
      override protected function initializeAttributeMapping() : void
      {
         super.initializeAttributeMapping();
         typeToMethodMap[SCROLL_BAR_CONTAINER] = this.bindScrollcontainerToScrollbar;
         attributeToMethodMap["source"] = this.handleAttributeSource;
         attributeToMethodMap["target"] = this.handleAttributeTarget;
         attributeToMethodMap["type"] = this.handleAttributeType;
      }
      
      public function create(param1:XML) : ICoreponent
      {
         var _loc2_:XMLList = param1.attributes();
         autoMapOwnProperties(null,_loc2_);
         this.bind();
         return null;
      }
      
      protected function handleAttributeSource(param1:ICoreponent, param2:String) : void
      {
         this._source = param2;
      }
      
      protected function handleAttributeTarget(param1:ICoreponent, param2:String) : void
      {
         this._target = param2;
      }
      
      protected function handleAttributeType(param1:ICoreponent, param2:String) : void
      {
         this._type = param2;
      }
      
      protected function bind() : void
      {
         var _loc1_:Function = null;
         if(this._source != null && this._target != null)
         {
            _loc1_ = typeToMethodMap[this._type] || typeToMethodMap[SCROLL_BAR_CONTAINER];
            _loc1_();
         }
      }
      
      protected function bindScrollcontainerToScrollbar() : void
      {
         var _loc1_:UIInstanceRepository = UIInstanceRepository.getInstance();
         var _loc2_:* = _loc1_.getICoreponentInstance(this._source);
         var _loc3_:* = _loc1_.getICoreponentInstance(this._target);
         BindingsUtils.bindScrollComponents(_loc3_ as IScrollContainer,_loc2_ as Scrollbar);
      }
   }
}

