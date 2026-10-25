package net.bigpoint.darkorbit.mvc.crafting.upgrade.model
{
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.delete_in_eic.ItemsDataUtility;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.TargetItemRecipeModel;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class UpgradeRecipeItemPair
   {
      
      public const changed:ISignal = new Signal();
      
      private var _item:ItemVO;
      
      private var _recipe:TargetItemRecipeModel;
      
      private var _id:Number;
      
      internal var parent:UpgradeTypeModel;
      
      internal var countedCollectible:Boolean;
      
      public function UpgradeRecipeItemPair(param1:Number)
      {
         super();
         this._id = param1;
      }
      
      public static function filterEmptyAndMaxed(param1:UpgradeRecipeItemPair, param2:int, param3:Vector.<UpgradeRecipeItemPair>) : Boolean
      {
         return Boolean(param1.item) && !ItemsDataUtility.isMaxLevel(param1.item);
      }
      
      public static function filterEmptyEquippedAndUnupgraded(param1:UpgradeRecipeItemPair, param2:int, param3:Vector.<UpgradeRecipeItemPair>) : Boolean
      {
         return Boolean(param1.item) && !ItemsDataUtility.isMinLevel(param1.item) && !param1.item.isEquipped;
      }
      
      public function get item() : ItemVO
      {
         return this._item;
      }
      
      public function set item(param1:ItemVO) : void
      {
         if(this._item != param1)
         {
            this._item = param1;
            this.handleChanged();
         }
      }
      
      public function get recipe() : TargetItemRecipeModel
      {
         return this._recipe;
      }
      
      public function set recipe(param1:TargetItemRecipeModel) : void
      {
         if(this._recipe != param1)
         {
            if(this._recipe)
            {
               this._recipe.stateChanged.remove(this.handleChanged);
            }
            this._recipe = param1;
            if(this._recipe)
            {
               this._recipe.stateChanged.add(this.handleChanged);
            }
            this.handleChanged();
         }
      }
      
      private function handleChanged() : void
      {
         if(this.parent != null)
         {
            this.parent.handlePairChanged(this);
         }
         this.changed.dispatch();
      }
      
      public function cleanup() : void
      {
         if(this._recipe != null)
         {
            this._recipe.stateChanged.remove(this.handleChanged);
         }
         this._item = null;
         this._recipe = null;
         this.parent = null;
         this.countedCollectible = false;
         this.changed.removeAll();
      }
      
      public function get empty() : Boolean
      {
         return !this._item && !this._recipe;
      }
      
      public function get id() : Number
      {
         return this._id;
      }
   }
}

