package net.bigpoint.darkorbit.mvc.ccCommands.view.comps
{
   import mx.core.ClassFactory;
   import net.bigpoint.darkorbit.com.module.CCAbstractRangeModule;
   import net.bigpoint.darkorbit.com.module.CCAttributeModule;
   import net.bigpoint.darkorbit.com.module.CCBooleanRangeModule;
   import net.bigpoint.darkorbit.com.module.CCDateRangeModule;
   import net.bigpoint.darkorbit.com.module.CCListRangeModule;
   import net.bigpoint.darkorbit.com.module.CCNumericRangeModule;
   
   public class CCComponentFactorySingleton
   {
      
      private static const ID_TO_CLASS:Object = {};
      
      ID_TO_CLASS[CCNumericRangeModule.instance.getLibcomModuleId()] = CCSlider;
      ID_TO_CLASS[CCListRangeModule.instance.getLibcomModuleId()] = CCList;
      ID_TO_CLASS[CCDateRangeModule.instance.getLibcomModuleId()] = CCDate;
      ID_TO_CLASS[CCBooleanRangeModule.instance.getLibcomModuleId()] = CCCheckbox;
      ID_TO_CLASS[CCAbstractRangeModule.instance.getLibcomModuleId()] = CCLabel;
      
      public function CCComponentFactorySingleton()
      {
         super();
      }
      
      public static function getRendererForType(param1:CCAttributeModule) : ClassFactory
      {
         return new ClassFactory(ID_TO_CLASS[param1.range.getLibcomModuleId()]);
      }
   }
}

