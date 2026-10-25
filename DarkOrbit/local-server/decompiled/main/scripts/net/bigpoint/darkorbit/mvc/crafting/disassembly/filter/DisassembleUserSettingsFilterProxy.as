package net.bigpoint.darkorbit.mvc.crafting.disassembly.filter
{
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterSettingsVO;
   import net.bigpoint.darkorbit.items.utils.ItemFilter;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeTypeUserSettingsFilterProxy;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   
   public class DisassembleUserSettingsFilterProxy extends UpgradeTypeUserSettingsFilterProxy implements IProxy
   {
      
      public static const NAME:String = "DisassembleUserSettingsFilterProxy";
      
      public function DisassembleUserSettingsFilterProxy()
      {
         super();
         this.proxyName = NAME;
      }
      
      override protected function initSettings() : void
      {
         _filterSettingsVO = new ItemFilterSettingsVO(ItemFilter.getFilterByType(ItemFilter.FILTER_TYPE_UPGRADE),"UPGRADE");
      }
   }
}

