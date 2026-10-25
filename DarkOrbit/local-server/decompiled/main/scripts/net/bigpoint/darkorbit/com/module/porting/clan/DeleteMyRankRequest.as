package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DeleteMyRankRequest implements IModule
   {
      
      private static var _instance:DeleteMyRankRequest;
      
      public function DeleteMyRankRequest()
      {
         super();
      }
      
      public static function get instance() : DeleteMyRankRequest
      {
         return _instance || (_instance = new DeleteMyRankRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24564;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-24564);
      }
   }
}

