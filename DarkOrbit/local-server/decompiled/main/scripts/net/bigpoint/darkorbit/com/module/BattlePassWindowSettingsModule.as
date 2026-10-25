package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattlePassWindowSettingsModule implements IModule
   {
      
      private static var _instance:BattlePassWindowSettingsModule;
      
      public var battlePassItemFilters:Vector.<String>;
      
      public function BattlePassWindowSettingsModule(param1:Vector.<String> = null)
      {
         super();
         if(param1 == null)
         {
            this.battlePassItemFilters = new Vector.<String>();
         }
         else
         {
            this.battlePassItemFilters = param1;
         }
      }
      
      public static function get instance() : BattlePassWindowSettingsModule
      {
         return _instance || (_instance = new BattlePassWindowSettingsModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6392;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.battlePassItemFilters.length > 0)
         {
            this.battlePassItemFilters.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.battlePassItemFilters.push(param1.readUTF());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:String = null;
         param1.writeShort(6392);
         param1.writeByte(this.battlePassItemFilters.length);
         for each(_loc2_ in this.battlePassItemFilters)
         {
            param1.writeUTF(_loc2_);
         }
      }
   }
}

