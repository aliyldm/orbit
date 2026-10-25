package net.bigpoint.darkorbit.fui.builder.xml.creators
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.builder.repository.UIInstanceRepository;
   
   public class RootCreator extends AbstractCreator
   {
      
      public function RootCreator()
      {
         super();
      }
      
      public function mapAttributes(param1:XML, param2:DisplayObjectContainer = null) : void
      {
         var _loc3_:Object = null;
         var _loc4_:XMLList = null;
         if(param2)
         {
            _loc3_ = param2;
            _loc4_ = param1.attributes();
            autoMapOwnProperties(_loc3_,_loc4_);
         }
      }
      
      override protected function initializeAttributeMapping() : void
      {
         attributeToMethodMap[AbstractCreator.ATTRIBUTENAME_DEFAULT_LIBRARY] = this.handleDefaultLibraryAttribute;
         attributeToMethodMap[AbstractCreator.ATTRIBUTENAME_MODULE_NAME] = this.handleModuleNameAttribute;
      }
      
      private function handleDefaultLibraryAttribute(param1:Object, param2:String) : void
      {
         if(!param2)
         {
         }
      }
      
      private function handleModuleNameAttribute(param1:Object, param2:String) : void
      {
         if(param2)
         {
            UIInstanceRepository.defaultModuleName = param2;
         }
      }
   }
}

