package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AbilityStatusFullCommand implements IModule
   {
      
      private static var _instance:AbilityStatusFullCommand;
      
      public var abilities:Vector.<AbilityStatusSingleCommand>;
      
      public function AbilityStatusFullCommand(param1:Vector.<AbilityStatusSingleCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.abilities = new Vector.<AbilityStatusSingleCommand>();
         }
         else
         {
            this.abilities = param1;
         }
      }
      
      public static function get instance() : AbilityStatusFullCommand
      {
         return _instance || (_instance = new AbilityStatusFullCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 277;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:AbilityStatusSingleCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.abilities.length > 0)
         {
            this.abilities.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = AbilityStatusSingleCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.abilities.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:AbilityStatusSingleCommand = null;
         param1.writeShort(277);
         param1.writeByte(this.abilities.length);
         for each(_loc2_ in this.abilities)
         {
            _loc2_.write(param1);
         }
      }
   }
}

