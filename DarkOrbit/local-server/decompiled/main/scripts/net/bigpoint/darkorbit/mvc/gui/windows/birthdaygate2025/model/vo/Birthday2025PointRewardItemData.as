package net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model.vo
{
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   
   public class Birthday2025PointRewardItemData
   {
      
      public var lootId:String = "";
      
      public var lootAmount:int = 0;
      
      public var bg:String = "";
      
      public var isClaim:Boolean = false;
      
      public var itemVo:ItemVO;
      
      public var index:int = 1;
      
      public var isLast:Boolean = false;
      
      public var canClaim:Boolean = false;
      
      public function Birthday2025PointRewardItemData(param1:String = "", param2:int = 0, param3:String = "")
      {
         super();
         this.lootId = param1;
         this.lootAmount = param2;
         this.bg = param3;
         this.itemVo = ItemDataProviderHelper.getItem(this.lootId);
      }
   }
}

