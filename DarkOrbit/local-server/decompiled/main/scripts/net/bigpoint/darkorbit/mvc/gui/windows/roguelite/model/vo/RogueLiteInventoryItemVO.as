package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.UnstableAttributeModule;
   import net.bigpoint.darkorbit.delete_in_eic.Constants;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class RogueLiteInventoryItemVO
   {
      
      public var equippedChanged:ISignal = new Signal();
      
      private var _itemVO:ItemVO;
      
      private var _loadState:Boolean;
      
      private var _equipped:Boolean;
      
      private var _unstableAttributes:Vector.<UnstableAttributeModule> = new Vector.<UnstableAttributeModule>(0);
      
      private var _unstableStats:String;
      
      public function RogueLiteInventoryItemVO(param1:ItemVO, param2:Vector.<UnstableAttributeModule> = null)
      {
         super();
         this._itemVO = param1;
         this._loadState = this._itemVO.isEquipped;
         this._equipped = this._loadState;
         this._unstableAttributes = param2;
         this.setUnstableStats();
      }
      
      public function get itemVO() : ItemVO
      {
         return this._itemVO;
      }
      
      public function get stateChanged() : Boolean
      {
         return this.equipped != this._loadState;
      }
      
      public function update() : void
      {
         this._loadState = this.equipped;
      }
      
      public function reset() : void
      {
         this.equipped = this._loadState;
      }
      
      public function get equipped() : Boolean
      {
         return this._equipped;
      }
      
      public function set equipped(param1:Boolean) : void
      {
         if(this.itemVO == null)
         {
            return;
         }
         this._equipped = param1;
         this.equippedChanged.dispatch();
      }
      
      public function get isUnstableModule() : Boolean
      {
         return this._unstableAttributes != null;
      }
      
      public function get unstableStats() : String
      {
         return this._unstableStats;
      }
      
      private function setUnstableStats() : void
      {
         var _loc1_:UnstableAttributeModule = null;
         this._unstableStats = "";
         if(!this._unstableAttributes)
         {
            return;
         }
         for each(_loc1_ in this._unstableAttributes)
         {
            this._unstableStats += (_loc1_.boostValue > 0 ? "+" : "") + TextFormatter.roundInteger(_loc1_.boostValue) + "% " + BPLocale.getItemInCategory(Constants.BPLOCAL_CATEGORY__ITEMS,"items_equipment_shipupgrade_modifiertype_" + _loc1_.attribute.toLowerCase()) + "\n";
         }
      }
   }
}

