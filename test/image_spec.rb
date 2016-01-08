require 'serverspec'
set :backend, :exec

describe "SD-Card Images" do
  @image_files = Dir.glob('/workspace/image-builder-rpi-*.img').entries

  @image_files.each do |image_file|
    describe "SD-Card Image file: #{image_file}" do
      it "exists" do
        file = file(image_file)

        expect(file).to exist
      end

      context "Partition table" do
        let(:result) { command("guestfish add #{image_file} : run : list-filesystems").stdout }

        it "has two partitions" do
          partitions = result.split(/\r?\n/)

          expect(partitions.size).to be 2
        end

        it "has a boot-partition with a vfat filesystem" do
          expect(result).to contain('sda1: vfat')
        end

        it "has a root-partition with a ext4 filesystem" do
          expect(result).to contain('sda2: ext4')
        end
      end

    end
  end

end
