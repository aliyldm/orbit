package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchGetRewardPackageCommand implements IModule
   {
      
      private static var _instance:DispatchGetRewardPackageCommand;
      
      public var name:String = "";
      
      public var rewards:Vector.<RewardContentModule>;
      
      public function DispatchGetRewardPackageCommand(param1:String = "", param2:Vector.<RewardContentModule> = null)
      {
         super();
         this.name = param1;
         if(param2 == null)
         {
            this.rewards = new Vector.<RewardContentModule>();
         }
         else
         {
            this.rewards = param2;
         }
      }
      
      public static function get instance() : DispatchGetRewardPackageCommand
      {
         return _instance || (_instance = new DispatchGetRewardPackageCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 29655;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardContentModule = null;
         this.name = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rewards.length > 0)
         {
            this.rewards.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RewardContentModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rewards.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardContentModule = null;
         param1.writeShort(29655);
         param1.writeUTF(this.name);
         param1.writeByte(this.rewards.length);
         for each(_loc2_ in this.rewards)
         {
            _loc2_.write(param1);
         }
      }
   }
}

