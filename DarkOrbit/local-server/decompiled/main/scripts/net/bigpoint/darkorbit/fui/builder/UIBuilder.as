package net.bigpoint.darkorbit.fui.builder
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.repository.IUITemplateRepository;
   import net.bigpoint.darkorbit.fui.builder.xml.XMLBasedUIBuilder;
   
   public class UIBuilder implements IUIBuilder
   {
      
      private var _builders:Dictionary = new Dictionary();
      
      public function UIBuilder(param1:Dictionary = null)
      {
         super();
         if(param1)
         {
            this.builders = param1;
         }
         else
         {
            this.addBuilder(new XMLBasedUIBuilder());
         }
      }
      
      public function set builders(param1:Dictionary) : void
      {
         this._builders = param1;
      }
      
      public function get builders() : Dictionary
      {
         return this._builders;
      }
      
      public function addBuilder(param1:IUIBuilderType) : void
      {
         var _loc2_:String = null;
         if(this._builders)
         {
            _loc2_ = param1.type;
            this._builders[_loc2_] = param1;
         }
      }
      
      public function build(param1:Object, param2:DisplayObjectContainer = null, param3:Boolean = false, param4:Boolean = false, param5:Function = null) : void
      {
         var _loc6_:String = typeof param1;
         var _loc7_:IUIBuilder = this._builders[_loc6_];
         if(_loc7_)
         {
            _loc7_.build(param1,param2,param3,param4,param5);
         }
         else
         {
            UISystem.log("A builder for the UI descriptionName with the type= " + _loc6_ + " doesn´t exist. ",UISystem.LOG_LEVEL_WARN);
            UISystem.log("Please add this specific builder.",UISystem.LOG_LEVEL_WARN);
         }
      }
      
      public function getTemplateRepository(param1:String = null) : IUITemplateRepository
      {
         var _loc2_:IUITemplateRepository = null;
         var _loc3_:IUIBuilder = null;
         if(param1)
         {
            _loc3_ = this._builders[param1];
            if(_loc3_ != null)
            {
               _loc2_ = _loc3_.getTemplateRepository();
            }
         }
         return _loc2_;
      }
      
      public function buildComponent(param1:Object) : DisplayObject
      {
         var _loc2_:String = typeof param1;
         var _loc3_:IUIBuilder = this._builders[_loc2_];
         if(_loc3_)
         {
            return _loc3_.buildComponent(param1);
         }
         return null;
      }
   }
}

