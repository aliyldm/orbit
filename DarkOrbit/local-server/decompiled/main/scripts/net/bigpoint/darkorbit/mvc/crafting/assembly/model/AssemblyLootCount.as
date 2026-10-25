package net.bigpoint.darkorbit.mvc.crafting.assembly.model
{
   import com.bigpoint.utils.bindables.BindableNumber;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   
   public class AssemblyLootCount
   {
      
      public const count:BindableNumber = new BindableNumber();
      
      private var _total:Number = 0;
      
      private var _itemVO:ItemVO;
      
      private var _originalValue:Number;
      
      public function AssemblyLootCount(param1:ItemVO, param2:Number, param3:Number)
      {
         super();
         this._itemVO = param1;
         if(!this._itemVO)
         {
            throw new Error("itemVO must not be null");
         }
         this._originalValue = param2;
         this._total = param3;
      }
      
      public static function filterPositive(param1:AssemblyLootCount, param2:int, param3:Vector.<AssemblyLootCount>) : Boolean
      {
         return param1.total >= 0;
      }
      
      public static function filterNegative(param1:AssemblyLootCount, param2:int, param3:Vector.<AssemblyLootCount>) : Boolean
      {
         return param1.total < 0;
      }
      
      public function get lootId() : String
      {
         return this._itemVO.lootID;
      }
      
      public function get total() : Number
      {
         return this._total;
      }
      
      public function set total(param1:Number) : void
      {
         this._total = param1;
         this.count.changed.dispatch();
      }
      
      public function get itemVO() : ItemVO
      {
         return this._itemVO;
      }
      
      public function setCount(param1:Number) : void
      {
         this.count.value = param1;
      }
      
      public function get originalValue() : Number
      {
         return this._originalValue;
      }
   }
}

