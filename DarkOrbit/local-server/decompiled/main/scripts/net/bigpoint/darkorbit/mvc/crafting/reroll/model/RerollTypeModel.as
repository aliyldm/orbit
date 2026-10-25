package net.bigpoint.darkorbit.mvc.crafting.reroll.model
{
   import net.bigpoint.darkorbit.com.module.UnstableModuleModule;
   
   public class RerollTypeModel
   {
      
      public static const TYPE_DMG:int = 0;
      
      public static const TYPE_HP:int = 1;
      
      public static const TYPE_SHD:int = 2;
      
      public static const TYPE_SPC:int = 3;
      
      public static const TYPE_CANNON:int = 4;
      
      public static const TYPE_CANNON_SHIELD:int = 5;
      
      protected var rerollType:int = 0;
      
      protected var rerollList:Vector.<UnstableModuleModule> = new Vector.<UnstableModuleModule>(0);
      
      public function RerollTypeModel(param1:int)
      {
         super();
         this.rerollType = param1;
      }
      
      public function isRerollType(param1:int) : Boolean
      {
         return param1 == this.rerollType;
      }
      
      public function get getRerollType() : int
      {
         return this.rerollType;
      }
      
      public function get getRerollList() : Vector.<UnstableModuleModule>
      {
         return this.rerollList;
      }
      
      public function addRerollList(param1:UnstableModuleModule) : void
      {
         this.rerollList.push(param1);
      }
      
      public function replaceRerollList(param1:UnstableModuleModule) : void
      {
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         while(_loc3_ < this.rerollList.length)
         {
            if(param1.itemId == this.rerollList[_loc3_].itemId)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(_loc2_ != -1)
         {
            this.rerollList[_loc2_] = param1;
         }
      }
      
      public function removeRerollList(param1:int) : void
      {
         var _loc2_:int = int(this.rerollList.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            if(this.rerollList[_loc3_].itemId == param1)
            {
               this.rerollList.splice(_loc3_,1);
            }
            _loc3_--;
         }
      }
   }
}

