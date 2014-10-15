class StopState
  # train station status: already done ("DONE") or to be done ("TODO")
  @@DONE = 'DONE'
  @@TODO = 'TODO'

  def self.DONE
    @@DONE
 end
  def self.TODO
    @@TODO
 end
end
